import '../../domain/entities/schedule.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_local_data_source.dart';
import '../datasources/schedule_remote_data_source.dart';
import '../models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleLocalDataSource localDataSource;
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Schedule?> getScheduleById(String id) async {
    try {
      final remoteModel = await remoteDataSource.getScheduleById(id);
      await localDataSource.saveSchedule(remoteModel);
      return remoteModel.toEntity();
    } catch (e) {
      final model = await localDataSource.getScheduleById(id);
      return model?.toEntity();
    }
  }

  @override
  Future<List<Schedule>> getSchedulesForMedicine(String medicineId) async {
    try {
      final remoteModels = await remoteDataSource.getSchedules(medicineId: medicineId);
      for (var model in remoteModels) {
        await localDataSource.saveSchedule(model);
      }
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      final models = await localDataSource.getSchedulesForMedicine(medicineId);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<Schedule>> getSchedulesForUser(String userId) async {
    try {
      final remoteModels = await remoteDataSource.getSchedules(userId: userId);
      for (var model in remoteModels) {
        await localDataSource.saveSchedule(model);
      }
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      final models = await localDataSource.getSchedulesForUser(userId);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<void> saveSchedule(Schedule schedule) async {
    final model = ScheduleModel.fromEntity(schedule);
    try {
      await remoteDataSource.createSchedule(model);
      await localDataSource.saveSchedule(model);
    } catch (e) {
      // Offline fallback
      await localDataSource.saveSchedule(model);
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(Schedule schedule) async {
    final model = ScheduleModel.fromEntity(schedule);
    try {
      await remoteDataSource.updateSchedule(model.id, model);
      await localDataSource.saveSchedule(model);
    } catch (e) {
      await localDataSource.saveSchedule(model);
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      await remoteDataSource.deleteSchedule(id);
      await localDataSource.deleteSchedule(id);
    } catch (e) {
      await localDataSource.deleteSchedule(id);
      rethrow;
    }
  }
}
