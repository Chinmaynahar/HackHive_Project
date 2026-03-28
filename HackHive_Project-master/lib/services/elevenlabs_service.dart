import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ElevenLabsService {
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CONFIGURATION — Update these two values
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Your ElevenLabs API key
  static const String apiKey =
      'sk_60c955853e27c0e7b38a0359b1ab278d49111d97782a3194';

  /// Voice ID to use. Free-tier accounts can ONLY use default premade voices:
  ///   "pNInz6obpgDQGcFmaJgB" = Adam (deep male narrator)
  ///   "21m00Tcm4TlvDq8ikWAM" = Rachel (calm female)
  ///   "JBFqnCBsd6RMkjVDRZzb" = George (warm British male)
  ///   "EXAVITQu4vr4xnSDxMaL" = Bella (youthful female)
  ///   "ErXwobaYiN019PkySvjV" = Antoni (storyteller male)
  ///
  /// Library/community voices (like Ms9OTvWb99V6DwRHZn6q) require a PAID plan.
  static const String voiceId = 'pNInz6obpgDQGcFmaJgB';

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  static const String _baseUrl = 'https://api.elevenlabs.io/v1/text-to-speech';

  /// CORS proxy for Flutter Web — browsers block direct cross-origin API calls.
  /// corsproxy.io forwards all headers + body and adds CORS headers to response.
  static const String _corsProxy = 'https://corsproxy.io/?';

  /// In-memory cache so replayed scenes don't waste API quota
  static final Map<String, Uint8List> _audioCache = {};

  /// Converts [text] to speech audio bytes via ElevenLabs API.
  /// Returns the MP3 audio as [Uint8List], or null if the request fails.
  static Future<Uint8List?> getAudioBytes(String text) async {
    // Skip empty text
    if (text.trim().isEmpty) return null;

    // Return cached audio if we already fetched this exact text
    if (_audioCache.containsKey(text)) {
      debugPrint('ElevenLabs: Using cached audio');
      return _audioCache[text]!;
    }

    // Build the target URL
    final targetUrl = '$_baseUrl/$voiceId';

    // On Web, route through CORS proxy; on mobile, call directly
    final Uri url;
    if (kIsWeb) {
      url = Uri.parse('$_corsProxy${Uri.encodeComponent(targetUrl)}');
      debugPrint('ElevenLabs: Using CORS proxy for Web');
    } else {
      url = Uri.parse(targetUrl);
    }

    final body = json.encode({
      "text": text,
      "model_id": "eleven_multilingual_v2",
      "voice_settings": {
        "stability": 0.50,
        "similarity_boost": 0.75,
      }
    });

    debugPrint('ElevenLabs: Fetching audio for ${text.length} chars...');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'xi-api-key': apiKey,
              'Content-Type': 'application/json',
              'Accept': 'audio/mpeg',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        if (bytes.isEmpty) {
          debugPrint('ElevenLabs: Received empty response body');
          return null;
        }
        _audioCache[text] = bytes;
        debugPrint('ElevenLabs: Got ${bytes.length} bytes of audio');
        return bytes;
      }

      // Provide clear error messages for common issues
      final errorBody = response.body;
      switch (response.statusCode) {
        case 401:
          if (errorBody.contains('detected_unusual_activity') ||
              errorBody.contains('Free Tier')) {
            debugPrint(
              'ElevenLabs 401: Blocked by abuse detection or free tier. '
              'Response: $errorBody',
            );
          } else {
            debugPrint(
              'ElevenLabs 401: Invalid API key. Response: $errorBody',
            );
          }
          return null;
        case 402:
          debugPrint(
            'ElevenLabs 402: Paid plan required for this voice. Response: $errorBody',
          );
          return null;
        case 429:
          debugPrint('ElevenLabs 429: Rate limit reached.');
          return null;
        default:
          debugPrint('ElevenLabs error ${response.statusCode}: $errorBody');
          return null;
      }
    } catch (e) {
      debugPrint('ElevenLabs network error: $e');
      return null;
    }
  }
}
