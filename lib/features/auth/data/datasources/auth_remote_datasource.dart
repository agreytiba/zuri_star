import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';


abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({required String email, required String password});
  Future<AuthResponseModel> register({required String name, required String email, required String password});
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      
      final data = response.data['data'];
      return AuthResponseModel.fromJson(data); 
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Unknown Error');
    }
  }

  @override
  Future<AuthResponseModel> register({required String name, required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.registerEndpoint,
        data: {'name': name, 'email': email, 'password': password},
      );
      final data = response.data['data'];
      return AuthResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Unknown Error');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get(ApiConstants.userProfileEndpoint);
      final data = response.data['data'];
      return UserModel.fromJson(data['user']);
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Unknown Error');
    }
  }
}
