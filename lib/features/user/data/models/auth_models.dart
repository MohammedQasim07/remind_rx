import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginRequest {
  final String? email;
  final String? phoneCountryCode;
  final String? phone;
  final String password;

  LoginRequest({
    this.email,
    this.phoneCountryCode,
    this.phone,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String phoneCountryCode;
  final String phone;
  final String? password;
  final String? name;
  final Role role;
  final Gender gender;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? city;
  final String? country;
  final String? occupation;

  RegisterRequest({
    required this.email,
    required this.phoneCountryCode,
    required this.phone,
    this.password,
    this.name,
    required this.role,
    required this.gender,
    this.dateOfBirth,
    this.nationality,
    this.city,
    this.country,
    this.occupation,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final bool isSuccess;
  final String? data; // Holds the JWT token
  final String? msg;
  final int statusCode;

  AuthResponse({
    required this.isSuccess,
    this.data,
    this.msg,
    required this.statusCode,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
