import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _tts = FlutterTts();

  // Initialize settings for baby-friendly voice
  static Future<void> initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.2);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.2);

    List voices = await _tts.getVoices;
    for (var voice in voices) {
      if (voice.toString().toLowerCase().contains("female")) {
        await _tts.setVoice({"name": voice['name'], "locale": voice['locale']});
        break;
      }
    }
  }

  // Reusable speak function
  static Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _tts.stop();
      await _tts.speak(text);
    }
  }

  // Stop function
  static Future<void> stop() async {
    await _tts.stop();
  }
}
