// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String?,
      phoneCountryCode: json['phoneCountryCode'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phoneCountryCode': instance.phoneCountryCode,
      'phone': instance.phone,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      phoneCountryCode: json['phoneCountryCode'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String?,
      name: json['name'] as String?,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      nationality: json['nationality'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      occupation: json['occupation'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phoneCountryCode': instance.phoneCountryCode,
      'phone': instance.phone,
      'password': instance.password,
      'name': instance.name,
      'role': _$RoleEnumMap[instance.role]!,
      'gender': _$GenderEnumMap[instance.gender]!,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'nationality': instance.nationality,
      'city': instance.city,
      'country': instance.country,
      'occupation': instance.occupation,
    };

const _$RoleEnumMap = {
  Role.superAdmin: 0,
  Role.patient: 1,
  Role.patientSupervisor: 2,
};

const _$GenderEnumMap = {
  Gender.male: 0,
  Gender.female: 1,
  Gender.other: 2,
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      isSuccess: json['isSuccess'] as bool,
      data: json['data'] as String?,
      msg: json['msg'] as String?,
      statusCode: (json['statusCode'] as num).toInt(),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'data': instance.data,
      'msg': instance.msg,
      'statusCode': instance.statusCode,
    };
