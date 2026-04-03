import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String phoneCountryCode;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.phoneCountryCode,
  });

  @override
  List<Object?> get props => [name, email, password, phone, phoneCountryCode];
}

class LogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
