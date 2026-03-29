import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // 🔐 Keys
  static const _tokenKey = 'auth_token';

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Read token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Clear token
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Clear all
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
