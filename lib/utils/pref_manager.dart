import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  static const _USER_TOKEN = "USER_TOKEN";
  static const _USER_ID = "USER_ID";
  static const _USER_IMAGE = "USER_IMAGE";

  static Future<void> saveUserToken(String token) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_USER_TOKEN, token);
  }

  static Future<String> getUserToken() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_USER_TOKEN);
    return token;
  }

  static Future<void> saveUserId(int id) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_USER_ID, id);
  }

  static Future<int> getUserId() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_USER_ID);
  }

  static Future<void> saveUserImageUrl(String imageUrl) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_USER_IMAGE, imageUrl);
  }

  static Future<String> getUserImageUrl() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_USER_IMAGE);
  }
}