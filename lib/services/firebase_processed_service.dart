import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

/// Listens to Firebase Realtime Database for processed ML output.
///
/// Expected Firebase structure at [processedPath]:
/// {
///   "prediction": "A",
///   "confidence": 0.93,
///   "timestamp": 168...,
///   "source_path": "sensor_raw/latest",
///   "raw_sensor": { ... }
/// }
class FirebaseProcessedDataService {
  final String processedPath;
  final DatabaseReference _ref;
  StreamSubscription<DatabaseEvent>? _sub;
  final _controller = StreamController<Map<String, dynamic>?>.broadcast();

  FirebaseProcessedDataService({this.processedPath = 'ASL_Glove/processed/latest'})
      : _ref = FirebaseDatabase.instance.ref();

  Stream<Map<String, dynamic>?> get onProcessedData => _controller.stream;

  void startListening() {
    _sub = _ref.child(processedPath).onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        _controller.add(Map<String, dynamic>.from(data));
      } else {
        _controller.add(null);
      }
    });
  }

  void stopListening() {
    _sub?.cancel();
    _sub = null;
  }

  void dispose() {
    stopListening();
    _controller.close();
  }
}
