import 'package:isar/isar.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;
  late String email;
  
  @enumerated
  late Role role;

  UserModel();

  /// Map Domain Entity to Data Model
  factory UserModel.fromEntity(User user) {
    return UserModel()
      ..id = user.id
      ..name = user.name
      ..email = user.email
      ..role = user.role;
  }

  /// Map Data Model back to Domain Entity
  User toEntity() {
    return _UserImpl(
      id: id,
      name: name,
      email: email,
      role: role,
    );
  }
}

class _UserImpl extends User {
  const _UserImpl({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });
}
