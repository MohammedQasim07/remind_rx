import '../../domain/entities/dose_history.dart';
import '../../domain/repositories/dose_history_repository.dart';
import '../datasources/dose_history_local_data_source.dart';
import '../models/dose_history_model.dart';
import 'package:isar/isar.dart'; // Needed if DoseStatus logic requires Isar types, but we handle it via enums anyway

class DoseHistoryRepositoryImpl implements DoseHistoryRepository {
  final DoseHistoryLocalDataSource localDataSource;

  DoseHistoryRepositoryImpl(this.localDataSource);

  @override
  Future<DoseHistory?> getDoseHistoryById(String id) async {
    final model = await localDataSource.getDoseHistoryById(id);
    return model?.toEntity();
  }

  @override
  Future<List<DoseHistory>> getDoseHistoryForSchedule(String scheduleId) async {
    final models = await localDataSource.getDoseHistoryForSchedule(scheduleId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<DoseHistory>> getDoseHistoryForUser(String userId, DateTime from, DateTime to) async {
    final models = await localDataSource.getDoseHistoryForUser(userId, from, to);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveDoseHistory(DoseHistory history) async {
    final model = DoseHistoryModel.fromEntity(history);
    await localDataSource.saveDoseHistory(model);
  }

  @override
  Future<void> updateDoseHistoryStatus(String id, DoseStatus status, DateTime? actualTime) async {
    final model = await localDataSource.getDoseHistoryById(id);
    if (model != null) {
      model.status = status;
      model.actualTime = actualTime;
      await localDataSource.saveDoseHistory(model);
    }
  }

  @override
  Future<void> deleteDoseHistoriesForSchedule(String scheduleId) async {
    await localDataSource.deleteDoseHistoriesForSchedule(scheduleId);
  }
}
