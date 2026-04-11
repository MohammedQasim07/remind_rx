import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/auth_models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      try {
        final user = await authRepository.getCurrentUser();
        emit(Authenticated(user));
      } catch (e) {
        await _storage.delete(key: 'jwt_token');
        emit(Unauthenticated());
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      
      if (response.isSuccess) {
        final user = await authRepository.getCurrentUser();
        emit(Authenticated(user));
      } else {
        final errorMsg = response.msg ?? 'Login failed (Status: ${response.statusCode})';
        emit(AuthError(errorMsg));
      }
    } catch (e) {
      print('AuthBloc: Login Error: $e');
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.register(
        RegisterRequest(
          name: event.name,
          email: event.email,
          password: event.password,
          phone: event.phone,
          phoneCountryCode: event.phoneCountryCode,
          avatarPath: event.avatarPath,
        ),
      );
      
      if (response.isSuccess) {
        final user = await authRepository.getCurrentUser();
        emit(Authenticated(user));
      } else {
        final errorMsg = response.msg ?? 'Registration failed (Status: ${response.statusCode})';
        emit(AuthError(errorMsg));
      }
    } catch (e) {
      print('AuthBloc: Registration Error: $e');
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(Unauthenticated());
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<AuthState> emit) async {
    try {
      await authRepository.updateUser(event.user);
      emit(Authenticated(event.user));
    } catch (e) {
      // Offline fallback: keep the state authenticated but don't crash
      emit(Authenticated(event.user));
    }
  }
}
