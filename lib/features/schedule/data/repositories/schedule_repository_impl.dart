import '../../domain/entities/schedule.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_local_data_source.dart';
import '../models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleLocalDataSource localDataSource;

  ScheduleRepositoryImpl(this.localDataSource);

  @override
  Future<Schedule?> getScheduleById(String id) async {
    final model = await localDataSource.getScheduleById(id);
    return model?.toEntity();
  }

  @override
  Future<List<Schedule>> getSchedulesForMedicine(String medicineId) async {
    final models = await localDataSource.getSchedulesForMedicine(medicineId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Schedule>> getSchedulesForUser(String userId) async {
    final models = await localDataSource.getSchedulesForUser(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveSchedule(Schedule schedule) async {
    final model = ScheduleModel.fromEntity(schedule);
    await localDataSource.saveSchedule(model);
  }

  @override
  Future<void> updateSchedule(Schedule schedule) async {
    await saveSchedule(schedule);
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await localDataSource.deleteSchedule(id);
  }
}
