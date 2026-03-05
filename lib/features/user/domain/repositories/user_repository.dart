import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> getUserById(String id);
  Future<User?> getCurrentUser();
  Future<void> saveUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}
