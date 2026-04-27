import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rushd_firestore_service.dart';
import 'sensor_reading.dart';

class ReadingListener {
  final RushdFirestoreService _service = RushdFirestoreService();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  bool _isProcessing = false;

  void startListening() {
    _subscription = _service.listenForNewReadings().listen(
      (snapshot) async {
        if (_isProcessing) return;
        _isProcessing = true;

        try {
          final changes = snapshot.docChanges.where((change) {
            return change.type == DocumentChangeType.added ||
                change.type == DocumentChangeType.modified;
          }).toList();

          for (final change in changes) {
            final data = change.doc.data();
            if (data == null) continue;

            if ((data['status'] ?? 'received') != 'received') continue;

            final reading = SensorReading.fromDoc(change.doc);

            try {
              await _service.processReading(reading);
            } catch (e) {
              print('Error processing reading ${reading.id}: $e');
            }
          }
        } finally {
          _isProcessing = false;
        }
      },
      onError: (error) {
        print('Listener error: $error');
      },
    );
  }

  void stopListening() {
    _subscription?.cancel();
  }
}