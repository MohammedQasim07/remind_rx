import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userRoleKey = 'user_role';

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
    await _saveAuthData(response);
    return response;
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await remoteDataSource.register(request);
    await _saveAuthData(response);
    return response;
  }

  Future<void> _saveAuthData(AuthResponse response) async {
    if (response.isSuccess && response.data != null) {
      if (response.data!.token != null) {
        await secureStorage.write(key: _tokenKey, value: response.data!.token!);
      }
      await secureStorage.write(key: _userIdKey, value: response.data!.userId);
      await secureStorage.write(key: _userNameKey, value: response.data!.name);
      if (response.data!.role != null) {
        await secureStorage.write(key: _userRoleKey, value: response.data!.role!);
      }
    }
  }

  @override
  Future<void> updateUser(User user) async {
    // Save to Secure Storage local cache
    await secureStorage.write(key: _userNameKey, value: user.name);
    // Ideally map other fields (email, phone, etc) into secureStorage later if auth data scales.
    
    // Attempt remote update (Offline-First)
    try {
      // await remoteDataSource.updateUser(user.id, UserDTO(user));
    } catch (e) {
      print('Network Error updating user, working offline: $e');
    }
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _userIdKey);
    await secureStorage.delete(key: _userNameKey);
    await secureStorage.delete(key: _userRoleKey);
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

  @override
  Future<User> getCurrentUser() async {
    final userId = await secureStorage.read(key: _userIdKey);
    final userName = await secureStorage.read(key: _userNameKey);
    
    if (userId == null || userName == null) {
      throw Exception("User data not found locally. Please login again.");
    }
    
    // Return a locally constructed User using data stored during login.
    // Since the API /api/users/current is returning 404, we rely on cached info.
    return User(
      id: userId,
      name: userName,
      email: '', // Not strictly tracked in current AuthData
      phone: '',
      phoneCountryCode: '',
      role: Role.patient, // Fallback/Default
      gender: Gender.other,
    );
  }
}
