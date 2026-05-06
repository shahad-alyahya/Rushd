import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rushd_firestore_service.dart';
import 'sensor_reading.dart';

/// Listens for real-time Arduino sensor readings from Firestore and processes them.
class ReadingListener {
  final RushdFirestoreService _service = RushdFirestoreService();

  // Active subscription to the Firestore stream.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  // Prevents concurrent processing of multiple snapshots.
  bool _isProcessing = false;

  // Starts listening to new or modified sensor readings.
  void startListening() {
    _subscription = _service.listenForNewReadings().listen(
      (snapshot) async {
        if (_isProcessing) return;
        _isProcessing = true;

        try {
          // Filters for recently added or modified documents.
          final changes = snapshot.docChanges.where((change) {
            return change.type == DocumentChangeType.added ||
                change.type == DocumentChangeType.modified;
          }).toList();

          for (final change in changes) {
            final data = change.doc.data();
            if (data == null) continue;

            // Only process readings that are currently marked as 'received'.
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

  // Cancels the active stream subscription to free up resources.
  void stopListening() {
    _subscription?.cancel();
  }
}
