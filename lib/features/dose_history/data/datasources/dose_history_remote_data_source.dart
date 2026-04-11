import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/dose_history_model.dart';

part 'dose_history_remote_data_source.g.dart';

@RestApi()
abstract class DoseHistoryRemoteDataSource {
  factory DoseHistoryRemoteDataSource(Dio dio, {String baseUrl}) = _DoseHistoryRemoteDataSource;

  @GET("/api/dose-histories")
  Future<List<DoseHistoryModel>> getDoseHistory({
    @Query("MedicineId") String? medicineId,
    @Query("UserId") String? userId,
    @Query("PageNumber") int? pageNumber,
    @Query("PageSize") int? pageSize,
  });

  @GET("/api/dose-histories/{id}")
  Future<DoseHistoryModel> getDoseHistoryById(@Path("id") String id);

  @POST("/api/dose-histories")
  Future<void> createDoseHistory(@Body() DoseHistoryModel history);

  @PUT("/api/dose-histories/{id}")
  Future<void> updateDoseHistory(@Path("id") String id, @Body() DoseHistoryModel history);

  @DELETE("/api/dose-histories/{id}")
  Future<void> deleteDoseHistory(@Path("id") String id);
}
