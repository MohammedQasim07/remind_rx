import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';
import '../models/auth_models.dart';

part 'user_remote_data_source.g.dart';

@RestApi()
abstract class UserRemoteDataSource {
  factory UserRemoteDataSource(Dio dio, {String baseUrl}) = _UserRemoteDataSource;

  @POST("/api/auth/login")
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST("/api/auth/register")
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @GET("/api/users/current")
  Future<UserModel> getCurrentUser();
}
