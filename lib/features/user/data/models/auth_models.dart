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
  final String? phoneCountryCode;
  final String? phone;
  final String? password;
  final String? name;
  final Role? role;
  final Gender? gender;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? city;
  final String? country;
  final String? occupation;
  final String? avatarPath;

  RegisterRequest({
    required this.email,
    this.phoneCountryCode,
    this.phone,
    this.password,
    this.name,
    this.role,
    this.gender,
    this.dateOfBirth,
    this.nationality,
    this.city,
    this.country,
    this.occupation,
    this.avatarPath,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class AuthData {
  final String userId;
  final String name;
  final String? role;
  final String? token;

  AuthData({
    required this.userId,
    required this.name,
    this.role,
    this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => _$AuthDataFromJson(json);
  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final bool isSuccess;
  final AuthData? data; // Holds the AuthData object
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
