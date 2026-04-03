import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/medicine_model.dart';

part 'medicine_remote_data_source.g.dart';

@RestApi()
abstract class MedicineRemoteDataSource {
  factory MedicineRemoteDataSource(Dio dio, {String baseUrl}) = _MedicineRemoteDataSource;

  @GET("/api/medicines")
  Future<List<MedicineModel>> getMedicines({
    @Query("Name") String? name,
    @Query("UserId") String? userId,
    @Query("Type") int? type,
    @Query("Status") int? status,
    @Query("PageNumber") int? pageNumber,
    @Query("PageSize") int? pageSize,
  });

  @GET("/api/medicines/{id}")
  Future<MedicineModel> getMedicineById(@Path("id") String id);

  @POST("/api/medicines")
  Future<void> createMedicine(@Body() MedicineModel medicine);

  @PUT("/api/medicines/{id}")
  Future<void> updateMedicine(@Path("id") String id, @Body() MedicineModel medicine);

  @DELETE("/api/medicines/{id}")
  Future<void> deleteMedicine(@Path("id") String id);
}
