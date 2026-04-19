import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'rushd_firestore_service.dart';
import 'sensor_reading.dart';

class ReadingListenerPage extends StatefulWidget {
  const ReadingListenerPage({super.key});

  @override
  State<ReadingListenerPage> createState() => _ReadingListenerPageState();
}

class _ReadingListenerPageState extends State<ReadingListenerPage> {
  final RushdFirestoreService _service = RushdFirestoreService();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  bool _isListening = false;
  bool _isProcessing = false;
  String _message = 'Idle';

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _subscription = _service.listenForNewReadings().listen(
      (snapshot) async {
        if (_isProcessing) return;
        _isProcessing = true;

        try {
          final changes = snapshot.docChanges.where((change) {
            return change.type == DocumentChangeType.added ||
                change.type == DocumentChangeType.modified;
          }).toList();

          if (changes.isEmpty) {
            if (mounted) {
              setState(() {
                _isListening = true;
                _message = 'Listening for new readings...';
              });
            }
            return;
          }

          for (final change in changes) {
            final data = change.doc.data();
            if (data == null) continue;
            if ((data['status'] ?? 'received') != 'received') continue;

            final reading = SensorReading.fromDoc(change.doc);

            try {
              await _service.processReading(reading);

              if (mounted) {
                setState(() {
                  _isListening = true;
                  _message = 'Processed reading: ${reading.id}';
                });
              }
            } catch (e) {
              if (mounted) {
                setState(() {
                  _message = 'Error processing ${reading.id}: $e';
                });
              }
            }
          }
        } finally {
          _isProcessing = false;
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isListening = false;
            _message = 'Listener error: $error';
          });
        }
      },
    );

    if (mounted) {
      setState(() {
        _isListening = true;
        _message = 'Listening for new readings...';
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rushd Reading Listener'),
      ),
      body: Center(
        child: Text(
          'Listening: $_isListening\n\n$_message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}