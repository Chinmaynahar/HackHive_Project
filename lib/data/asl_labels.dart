/// Letters that the ASL ML model can detect, extracted from asl_dataset CSV.
/// These are used to randomize checkpoint options in story mode so that
/// gesture detection only assigns letters the model actually recognises.
class AslLabels {
  AslLabels._();

  /// Unique labels present in the asl_dataset CSV file.
  static const List<String> detectable = [
    'A', 'B', 'D', 'E', 'F', 'G', 'I', 'J', 'K',
    'L', 'Q', 'S', 'U', 'W', 'X', 'Y', 'Z',
  ];
}
