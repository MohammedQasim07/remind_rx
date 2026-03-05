import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<User?> getUserById(String id) async {
    final model = await localDataSource.getUserById(id);
    return model?.toEntity();
  }

  @override
  Future<User?> getCurrentUser() async {
    final model = await localDataSource.getCurrentUser();
    return model?.toEntity();
  }

  @override
  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    await localDataSource.saveUser(model);
  }

  @override
  Future<void> updateUser(User user) async {
    // In Isar, put() inserts or updates.
    await saveUser(user);
  }

  @override
  Future<void> deleteUser(String id) async {
    await localDataSource.deleteUser(id);
  }
}
