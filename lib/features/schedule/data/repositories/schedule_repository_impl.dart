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
      final payload = {
        "medicineId": model.medicineId,
        "startDate": model.startDate.toIso8601String(),
        "endDate": model.endDate?.toIso8601String(),
        "reminderTime": model.reminderTime.toIso8601String(),
        "repeatType": model.repeatType.index,
        "repeatInterval": model.repeatInterval,
        "daysOfWeek": model.daysOfWeek,
        "isActive": model.isActive,
        "notes": model.notes,
      };
      await remoteDataSource.createSchedule(payload);
      await localDataSource.saveSchedule(model);
    } catch (e) {
      // Offline fallback: log and proceed
      print('Network Error saving schedule, syncing later: $e');
      await localDataSource.saveSchedule(model);
    }
  }

  @override
  Future<void> updateSchedule(Schedule schedule) async {
    final model = ScheduleModel.fromEntity(schedule);
    try {
      final payload = {
        "medicineId": model.medicineId,
        "startDate": model.startDate.toIso8601String(),
        "endDate": model.endDate?.toIso8601String(),
        "reminderTime": model.reminderTime.toIso8601String(),
        "repeatType": model.repeatType.index,
        "repeatInterval": model.repeatInterval,
        "daysOfWeek": model.daysOfWeek,
        "isActive": model.isActive,
        "notes": model.notes,
      };
      await remoteDataSource.updateSchedule(model.id, payload);
      await localDataSource.saveSchedule(model);
    } catch (e) {
      print('Network Error updating schedule, syncing later: $e');
      await localDataSource.saveSchedule(model);
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
