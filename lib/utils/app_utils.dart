import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_media/models/user.dart';

class AppUtils {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // static Future<String?> getAccessToken() =>
  //     _storage.read(key: 'accessToken_key');

  // ///Store the access token of the corresponding user id
  // static Future<void> setAccessToken(String value) async {
  //   getIt<Api>().accessToken = value;

  //   return _storage.write(key: 'accessToken_key', value: value);
  // }

  // //Delete the accesstoken
  // static Future<bool> clearAccessToken() async {
  //   await _storage.delete(key: 'accessToken_key');
  //   getIt<Api>().accessToken = "";
  //   return true;
  // }

  static Future<bool> saveUserDetails(User user) async {
    await _storage.write(
        key: 'user_details_key', value: jsonEncode(user.toJson()));
    return true;
  }

  static Future<bool> clearUserDetails() async {
    await _storage.delete(key: 'user_details_key');
    return true;
  }

  static Future<User?> getUserDetails() async {
    try {
      final userString = await _storage.read(key: 'user_details_key');
      if (userString == null) {
        return null;
      }
      final decoded = jsonDecode(userString);

      return User.fromJson(decoded);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<void> logout() async {
    clearUserDetails();
  }
}
