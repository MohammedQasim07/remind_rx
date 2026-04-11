import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/user_remote_data_source.dart';
import '../datasources/user_local_data_source.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userAvatarKey = 'user_avatar';
  static const String _userRoleKey = 'user_role';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
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
    print('AuthRepository: Saving auth data. Success: ${response.isSuccess}');
    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      print('AuthRepository: User ID: ${data.userId}, Name: ${data.name}');
      
      if (data.token != null && data.token!.isNotEmpty) {
        await secureStorage.write(key: _tokenKey, value: data.token!);
      }
      
      await secureStorage.write(key: _userIdKey, value: data.userId);
      await secureStorage.write(key: _userNameKey, value: data.name);
      if (data.role != null) {
        await secureStorage.write(key: _userRoleKey, value: data.role!);
      }
      
      // Save or update Isar generic memory
      var localUser = await localDataSource.getUserById(data.userId);
      if (localUser == null) {
        localUser = UserModel()
          ..id = data.userId
          ..name = data.name ?? 'User'
          ..email = ''
          ..phone = ''
          ..phoneCountryCode = ''
          ..role = Role.patient
          ..gender = Gender.other;
        await localDataSource.saveUser(localUser);
      }
      
      print('AuthRepository: Auth data saved successfully.');
    } else {
      print('AuthRepository: Skipping save. Success: ${response.isSuccess}, Data: ${response.data != null}');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    // Save to Secure Storage local cache
    await secureStorage.write(key: _userNameKey, value: user.name);
    if (user.avatarPath != null) {
      await secureStorage.write(key: _userAvatarKey, value: user.avatarPath!);
    }
    
    // Subconscious Memory: Persist fully in Isar Database
    await localDataSource.saveUser(UserModel.fromEntity(user));
    
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
    await secureStorage.delete(key: _userAvatarKey);
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
    final userAvatar = await secureStorage.read(key: _userAvatarKey);
    
    print('AuthRepository: Reading local user. ID: $userId, Name: $userName');
    
    if (userId == null || userId.isEmpty || userName == null || userName.isEmpty) {
      throw Exception("User data missing or invalid (ID: $userId, Name: $userName). Please login again.");
    }
    
    // Subconscious Memory Magic: Retrieve user profile robustly from Isar Database
    final localUser = await localDataSource.getUserById(userId);
    if (localUser != null) {
       return localUser.toEntity();
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
      avatarPath: userAvatar,
    );
  }
}
