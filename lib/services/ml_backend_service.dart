import 'dart:convert';
import 'package:http/http.dart' as http;

const String backendBaseUrl = String.fromEnvironment(
  'BACKEND_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);

class MLBackendService {
  final Uri backendUri;

  MLBackendService({Uri? backendUri})
      : backendUri = backendUri ?? Uri.parse(backendBaseUrl);

  Future<Map<String, dynamic>> triggerClassification({
    String sensorPath = 'ASL_Glove/sensors',
    String outputPath = 'ASL_Glove/processed/latest',
  }) async {
    final uri = backendUri.replace(
      path: '/predict/firebase/store',
      queryParameters: {
        'sensor_path': sensorPath,
        'output_path': outputPath,
      },
    );

    final response = await http.post(uri);
    if (response.statusCode != 200) {
      throw Exception(
          'Backend returned ${response.statusCode}: ${response.body}');
    }

    final payload = jsonDecode(response.body);
    if (payload is! Map<String, dynamic>) {
      throw Exception('Unexpected backend response.');
    }

    return payload;
  }
}
