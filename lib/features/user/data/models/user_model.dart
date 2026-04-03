import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@collection
@JsonSerializable()
class UserModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;
  late String email;
  late String phone;
  late String phoneCountryCode;
  
  @enumerated
  late Role role;
  
  @enumerated
  late Gender gender;
  
  DateTime? dateOfBirth;
  String? nationality;
  String? city;
  String? country;
  String? occupation;

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel()
      ..id = user.id
      ..name = user.name
      ..email = user.email
      ..phone = user.phone
      ..phoneCountryCode = user.phoneCountryCode
      ..role = user.role
      ..gender = user.gender
      ..dateOfBirth = user.dateOfBirth
      ..nationality = user.nationality
      ..city = user.city
      ..country = user.country
      ..occupation = user.occupation;
  }

  User toEntity() {
    return _UserImpl(
      id: id,
      name: name,
      email: email,
      phone: phone,
      phoneCountryCode: phoneCountryCode,
      role: role,
      gender: gender,
      dateOfBirth: dateOfBirth,
      nationality: nationality,
      city: city,
      country: country,
      occupation: occupation,
    );
  }
}

class _UserImpl extends User {
  const _UserImpl({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.phoneCountryCode,
    required super.role,
    required super.gender,
    super.dateOfBirth,
    super.nationality,
    super.city,
    super.country,
    super.occupation,
  });
}
