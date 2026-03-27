import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

/// Listens to Firebase Realtime Database for gesture data from the glove.
///
/// Expected Firebase structure at [gesturePath]:
/// {
///   "letter": "A",       // The detected alphabet gesture
///   "timestamp": 123...  // Epoch ms when the gesture was detected
/// }
class FirebaseGestureService {
  final String gesturePath;
  final DatabaseReference _ref;
  StreamSubscription<DatabaseEvent>? _sub;
  final _controller = StreamController<String>.broadcast();

  FirebaseGestureService({this.gesturePath = 'glove/gesture'})
      : _ref = FirebaseDatabase.instance.ref();

  /// Stream of detected gesture letters (e.g. "A", "B", "C").
  Stream<String> get onGesture => _controller.stream;

  /// Start listening for gesture updates in Firebase.
  void startListening() {
    _sub = _ref.child(gesturePath).onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final letter = data['letter'];
        if (letter is String && letter.isNotEmpty) {
          _controller.add(letter.toUpperCase());
        }
      }
    });
  }

  /// Stop listening and clean up.
  void stopListening() {
    _sub?.cancel();
    _sub = null;
  }

  /// Dispose all resources.
  void dispose() {
    stopListening();
    _controller.close();
  }
}
