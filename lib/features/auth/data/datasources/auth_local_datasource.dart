import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/api_constants.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  const AuthLocalDataSourceImpl({this.secureStorage = const FlutterSecureStorage()});

  @override
  Future<void> saveToken(String token) {
    return secureStorage.write(key: StorageConstants.tokenKey, value: token);
  }

  @override
  Future<String?> getToken() {
    return secureStorage.read(key: StorageConstants.tokenKey);
  }

  @override
  Future<void> deleteToken() {
    return secureStorage.delete(key: StorageConstants.tokenKey);
  }
}
