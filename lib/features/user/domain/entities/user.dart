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
  });
}
