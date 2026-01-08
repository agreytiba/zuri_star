class ApiConstants {
  static const String baseUrl = 'https://api.example.com/v1';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String userProfileEndpoint = '/users/me';
  
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

class StorageConstants {
  static const String tokenKey = 'auth_token';
  static const String themeKey = 'theme_mode';
  static const String userBox = 'user_box';
}
