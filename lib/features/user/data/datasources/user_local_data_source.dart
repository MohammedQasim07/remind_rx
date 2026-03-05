import '../models/user_model.dart';
import 'package:isar/isar.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getUserById(String id);
  Future<UserModel?> getCurrentUser();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Isar isar;

  UserLocalDataSourceImpl(this.isar);

  @override
  Future<UserModel?> getUserById(String id) async {
    return await isar.userModels.filter().idEqualTo(id).findFirst();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // For local-first, the first user might be considered the "current" user,
    // or you could filter by a specific 'isCurrentUser' boolean.
    // Assuming single-device user for now.
    return await isar.userModels.where().findFirst();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }

  @override
  Future<void> deleteUser(String id) async {
    await isar.writeTxn(() async {
      final user = await getUserById(id);
      if (user != null) {
        await isar.userModels.delete(user.isarId);
      }
    });
  }
}
