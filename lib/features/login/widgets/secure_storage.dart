import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton instance
  static final SecureStorageService _instance = SecureStorageService._internal();
  
  // Factory constructor to return the same instance
  factory SecureStorageService() => _instance;
  
  // Private constructor
  SecureStorageService._internal();
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'my_secure_app',
      publicKey: 'my_public_key',
    ),
  );

  // Store a value
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read a value
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a value
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all values
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}