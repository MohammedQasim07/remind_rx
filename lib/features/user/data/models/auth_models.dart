import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
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
  @JsonKey(name: 'userId', defaultValue: '')
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

  factory AuthData.fromJson(Map<String, dynamic> json) {
    // Custom handling for 'user_id' or 'id' if 'userId' is missing in the map but id exists
    final map = Map<String, dynamic>.from(json);
    if (!map.containsKey('userId')) {
      map['userId'] = (map['id'] ?? map['user_id'] ?? '').toString();
    }
    return _$AuthDataFromJson(map);
  }
  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'isSuccess', defaultValue: false)
  final bool isSuccess;
  
  final AuthData? data; // Holds the AuthData object
  
  @JsonKey(name: 'message')
  final String? msg;
  
  final int statusCode;

  AuthResponse({
    required this.isSuccess,
    this.data,
    this.msg,
    required this.statusCode,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    // Support both 'isSuccess' and 'success'
    if (!map.containsKey('isSuccess')) {
      map['isSuccess'] = map['success'] ?? false;
    }
    // Support both 'msg' and 'message'
    if (!map.containsKey('msg')) {
      map['msg'] = map['message'];
    }
    
    // Fix API mismatch: if 'data' is returned as a plain JWT string on registration success, decode it!
    if (map['data'] is String) {
      String token = map['data'] as String;
      String userId = 'unknown_user_id';
      String role = 'Member';
      
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          String payload = parts[1];
          while (payload.length % 4 != 0) { payload += '='; }
          final decoded = utf8.decode(base64Url.decode(payload));
          final Map<String, dynamic> jwtData = jsonDecode(decoded);
          
          userId = jwtData['nameid'] ?? jwtData['userId'] ?? jwtData['sub'] ?? 'unknown_user_id';
          role = jwtData['role'] ?? 'Member';
        }
      } catch (_) {}

      map['data'] = {
        'userId': userId,
        'name': 'User',
        'role': role,
        'token': token,
      };
    }
    return _$AuthResponseFromJson(map);
  }
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
