import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserRoleResult {
  final String role;
  final bool requiresVerification;

  AppUserRoleResult({
    required this.role,
    required this.requiresVerification,
  });
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  Future<String?> signUpUser({
    required String fullName,
    required String email,
    required String password,
    String assignedLocationId = 'location_001',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) return 'Failed to create account';

      await user.sendEmailVerification();

      await _usersRef.doc(user.uid).set({
        'fullName': fullName.trim(),
        'email': email.trim().toLowerCase(),
        'role': 'user',
        'assignedLocationId': assignedLocationId,
        'isVerified': false,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }

  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<AppUserRoleResult?> getCurrentUserRole() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    await currentUser.reload();

    final doc = await _usersRef.doc(currentUser.uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    final role = (data['role'] ?? 'user').toString().trim().toLowerCase();
    final status = (data['status'] ?? 'active').toString().trim().toLowerCase();

    if (status != 'active') {
      await signOut();
      return null;
    }

    final isVerifiedFromAuth = currentUser.emailVerified;
    final isVerifiedFromDb = data['isVerified'] ?? false;

    if (isVerifiedFromAuth && !isVerifiedFromDb) {
      await _usersRef.doc(currentUser.uid).update({
        'isVerified': true,
      });
    }

    final requiresVerification =
        role == 'user' && !(isVerifiedFromAuth || isVerifiedFromDb);

    return AppUserRoleResult(
      role: role,
      requiresVerification: requiresVerification,
    );
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    if (currentUser.email != email.trim()) {
      await currentUser.verifyBeforeUpdateEmail(email.trim());
    }

    await _usersRef.doc(currentUser.uid).update({
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}