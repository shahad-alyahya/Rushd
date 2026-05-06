import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Model to hold the user's role and verification requirement status
class AppUserRoleResult {
  final String role;
  final bool requiresVerification;

  AppUserRoleResult({
    required this.role,
    required this.requiresVerification,
  });
}

class AuthService {
  // Singleton pattern to ensure only one instance of AuthService exists
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Stream to listen to real-time authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
// Getter for the currently logged-in Firebase user
  User? get currentUser => _auth.currentUser;
// Reference to the 'users' collection in Firestore
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');
// Registers a new user, sends verification email, and creates a Firestore profile
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
// Send initial verification email
      await user.sendEmailVerification();
// Store additional user data in Firestore with default 'user' role
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
// Authenticates an existing user
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
// Manually resend verification email if needed
  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
// Refreshes the local user object to get the latest data (e.g., emailVerified status)
  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }
// Sends a password reset link to the provided email
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
// Fetches user role and checks if they need to verify their email
  Future<AppUserRoleResult?> getCurrentUserRole() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;
// Reload to ensure emailVerified status is up to date
    await currentUser.reload();

    final doc = await _usersRef.doc(currentUser.uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    final role = (data['role'] ?? 'user').toString().trim().toLowerCase();
    final status = (data['status'] ?? 'active').toString().trim().toLowerCase();
// Force sign out if the account status is not 'active'
    if (status != 'active') {
      await signOut();
      return null;
    }

    final isVerifiedFromAuth = currentUser.emailVerified;
    final isVerifiedFromDb = data['isVerified'] ?? false;
// Sync Firestore 'isVerified' flag if email is verified in Firebase Auth
    if (isVerifiedFromAuth && !isVerifiedFromDb) {
      await _usersRef.doc(currentUser.uid).update({
        'isVerified': true,
      });
    }
// Determine if the user should be blocked by a verification screen
    final requiresVerification =
        role == 'user' && !(isVerifiedFromAuth || isVerifiedFromDb);

    return AppUserRoleResult(
      role: role,
      requiresVerification: requiresVerification,
    );
  }
// Updates user profile info and handles email changes with re-verification
  Future<void> updateProfile({
    required String fullName,
    required String email,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;
// If email is changed, Firebase will require verification for the new address
    if (currentUser.email != email.trim()) {
      await currentUser.verifyBeforeUpdateEmail(email.trim());
    }
// Update Firestore user document
    await _usersRef.doc(currentUser.uid).update({
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
    });
  }
// Logs the user out of the application
  Future<void> signOut() async {
    await _auth.signOut();
  }
}