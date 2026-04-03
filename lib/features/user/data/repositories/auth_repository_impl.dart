import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'jwt_token';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<AuthResponse> login({
    String? email,
    String? phone,
    String? phoneCountryCode,
    required String password,
  }) async {
    final request = LoginRequest(
      email: email,
      phoneCountryCode: phoneCountryCode,
      phone: phone,
      password: password,
    );

    final response = await remoteDataSource.login(request);
    if (response.isSuccess && response.data != null) {
      await secureStorage.write(key: _tokenKey, value: response.data);
    }
    return response;
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await remoteDataSource.register(request);
    if (response.isSuccess && response.data != null) {
      await secureStorage.write(key: _tokenKey, value: response.data);
    }
    return response;
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}
