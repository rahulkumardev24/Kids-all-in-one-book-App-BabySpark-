import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  /// Mute status
  static Future<void> saveMute(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("checkMute", value);
  }

  static Future<bool> loadMute() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("checkMute") ?? true;
  }

  static Future<void> playSound(
      {required String fileName, required bool isMute}) async {
    if (!isMute) return;

    final player = AudioPlayer();
    await player.play(AssetSource(fileName));
  }
}
