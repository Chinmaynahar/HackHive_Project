import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

/// Listens to Firebase Realtime Database for processed gesture predictions.
///
/// Primary: reads from [processedPath] (default: ASL_Glove/processed/latest):
/// {
///   "prediction": "A",
///   "confidence": 0.93,
///   "timestamp": 168...
/// }
///
/// Cross-reference: also reads [currentPath] (default: ASL_Glove/current)
/// for the hardcoded "letter" field. When both ML prediction and hardcoded
/// letter agree, the data is marked as cross-validated for extra accuracy.
class FirebaseGestureService {
  final String processedPath;
  final String currentPath;
  final DatabaseReference _ref;
  StreamSubscription<DatabaseEvent>? _processedSub;
  StreamSubscription<DatabaseEvent>? _currentSub;
  final _letterController = StreamController<String>.broadcast();
  final _dataController = StreamController<Map<String, dynamic>?>.broadcast();

  /// Latest hardcoded letter from ASL_Glove/current/letter
  String? _hardcodedLetter;

  FirebaseGestureService({
    this.processedPath = 'ASL_Glove/processed/latest',
    this.currentPath = 'ASL_Glove/current',
  }) : _ref = FirebaseDatabase.instance.ref();

  /// Stream of detected gesture letters (e.g. "A", "B", "C").
  Stream<String> get onGesture => _letterController.stream;

  /// Stream of full processed data (prediction + confidence + timestamp).
  /// Includes extra field 'crossValidated' (bool) when hardcoded letter matches.
  Stream<Map<String, dynamic>?> get onProcessedData => _dataController.stream;

  /// Start listening for gesture updates in Firebase.
  void startListening() {
    debugPrint('[GestureService] Starting listeners — processed: $processedPath, current: $currentPath');

    // ── Listen to hardcoded letter at ASL_Glove/current for cross-reference ──
    _currentSub = _ref.child(currentPath).onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final letter = data['letter']?.toString().toUpperCase();
        _hardcodedLetter = letter;
        debugPrint('[GestureService] Current/letter updated: $_hardcodedLetter');
      }
    });

    // ── Listen to ML-processed predictions at ASL_Glove/processed/latest ──
    _processedSub = _ref.child(processedPath).onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final prediction = map['prediction']?.toString().toUpperCase();
        final confidence = map['confidence'];
        final timestamp = map['timestamp'];

        // Cross-validate with hardcoded letter
        final crossValidated = prediction != null &&
            _hardcodedLetter != null &&
            prediction == _hardcodedLetter;
        map['crossValidated'] = crossValidated;
        map['hardcodedLetter'] = _hardcodedLetter;

        debugPrint('[GestureService] ML prediction=$prediction, confidence=$confidence, ts=$timestamp');
        debugPrint('[GestureService]   hardcoded=$_hardcodedLetter, crossValidated=$crossValidated');

        _dataController.add(map);

        if (prediction != null && prediction.isNotEmpty) {
          _letterController.add(prediction);
        }
      } else {
        debugPrint('[GestureService] No processed data (null)');
        _dataController.add(null);
      }
    });
  }

  /// Stop listening and clean up.
  void stopListening() {
    _processedSub?.cancel();
    _processedSub = null;
    _currentSub?.cancel();
    _currentSub = null;
  }

  /// Dispose all resources.
  void dispose() {
    stopListening();
    _letterController.close();
    _dataController.close();
  }
}
