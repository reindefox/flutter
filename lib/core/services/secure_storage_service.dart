import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _keyUserEmail = 'user_email';
  static const String _keyUserToken = 'user_token';
  static const String _keyUserData = 'user_data';

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
          mOptions: MacOsOptions(),
        );

  Future<void> saveAuthData({
    required String email,
    String? token,
    Map<String, dynamic>? userData,
  }) async {
    await _storage.write(key: _keyUserEmail, value: email);
    if (token != null) {
      await _storage.write(key: _keyUserToken, value: token);
    }
    if (userData != null) {
      await _storage.write(key: _keyUserData, value: jsonEncode(userData));
    }
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  Future<String?> getUserToken() async {
    return await _storage.read(key: _keyUserToken);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _keyUserData);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> hasSession() async {
    final email = await getUserEmail();
    return email != null;
  }

  Future<void> clearAuthData() async {
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUserToken);
    await _storage.delete(key: _keyUserData);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
