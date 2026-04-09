import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/schedule_model.dart';

part 'schedule_remote_data_source.g.dart';

@RestApi()
abstract class ScheduleRemoteDataSource {
  factory ScheduleRemoteDataSource(Dio dio, {String baseUrl}) = _ScheduleRemoteDataSource;

  @GET("/api/schedules")
  Future<List<ScheduleModel>> getSchedules({
    @Query("MedicineId") String? medicineId,
    @Query("UserId") String? userId,
    @Query("PageNumber") int? pageNumber,
    @Query("PageSize") int? pageSize,
  });

  @GET("/api/schedules/{id}")
  Future<ScheduleModel> getScheduleById(@Path("id") String id);

  @POST("/api/schedules")
  Future<void> createSchedule(@Body() Map<String, dynamic> body);

  @PUT("/api/schedules/{id}")
  Future<void> updateSchedule(@Path("id") String id, @Body() Map<String, dynamic> body);

  @DELETE("/api/schedules/{id}")
  Future<void> deleteSchedule(@Path("id") String id);
}
