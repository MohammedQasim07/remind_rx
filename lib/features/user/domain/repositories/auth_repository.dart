import '../../domain/entities/user.dart';
import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({
    String? email,
    String? phone,
    String? phoneCountryCode,
    required String password,
  });

  Future<AuthResponse> register(RegisterRequest request);

  Future<void> logout();

  Future<String?> getToken();

  Future<bool> isAuthenticated();

  Future<User> getCurrentUser();
}
