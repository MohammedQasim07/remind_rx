import 'package:json_annotation/json_annotation.dart';

enum Role {
  @JsonValue(0) superAdmin,
  @JsonValue(1) patient,
  @JsonValue(2) patientSupervisor
}

enum Gender {
  @JsonValue(0) male,
  @JsonValue(1) female,
  @JsonValue(2) other
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String phoneCountryCode;
  final Role role;
  final Gender gender;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? city;
  final String? country;
  final String? occupation;
  final String? avatarPath;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.phoneCountryCode,
    required this.role,
    required this.gender,
    this.dateOfBirth,
    this.nationality,
    this.city,
    this.country,
    this.occupation,
    this.avatarPath,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? phoneCountryCode,
    Role? role,
    Gender? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? city,
    String? country,
    String? occupation,
    String? avatarPath,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      city: city ?? this.city,
      country: country ?? this.country,
      occupation: occupation ?? this.occupation,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
