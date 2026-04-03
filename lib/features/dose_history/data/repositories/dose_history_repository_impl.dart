import '../../domain/entities/dose_history.dart';
import '../../domain/repositories/dose_history_repository.dart';
import '../datasources/dose_history_local_data_source.dart';
import '../datasources/dose_history_remote_data_source.dart';
import '../models/dose_history_model.dart';

class DoseHistoryRepositoryImpl implements DoseHistoryRepository {
  final DoseHistoryLocalDataSource localDataSource;
  final DoseHistoryRemoteDataSource remoteDataSource;

  DoseHistoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<DoseHistory?> getDoseHistoryById(String id) async {
    try {
      final remoteModel = await remoteDataSource.getDoseHistoryById(id);
      await localDataSource.saveDoseHistory(remoteModel);
      return remoteModel.toEntity();
    } catch (e) {
      final model = await localDataSource.getDoseHistoryById(id);
      return model?.toEntity();
    }
  }

  @override
  Future<List<DoseHistory>> getDoseHistoryForSchedule(String scheduleId) async {
    try {
      final remoteModels = await remoteDataSource.getDoseHistory(medicineId: scheduleId); // Simplified query
      for (var model in remoteModels) {
        await localDataSource.saveDoseHistory(model);
      }
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      final models = await localDataSource.getDoseHistoryForSchedule(scheduleId);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<DoseHistory>> getDoseHistoryForUser(String userId, DateTime from, DateTime to) async {
    try {
      final remoteModels = await remoteDataSource.getDoseHistory(userId: userId);
      for (var model in remoteModels) {
        await localDataSource.saveDoseHistory(model);
      }
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      final models = await localDataSource.getDoseHistoryForUser(userId, from, to);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<void> saveDoseHistory(DoseHistory history) async {
    final model = DoseHistoryModel.fromEntity(history);
    try {
      await remoteDataSource.createDoseHistory(model);
      await localDataSource.saveDoseHistory(model);
    } catch (e) {
      await localDataSource.saveDoseHistory(model);
      rethrow;
    }
  }

  @override
  Future<void> updateDoseHistoryStatus(String id, DoseStatus status, DateTime? actualTime) async {
    final model = await localDataSource.getDoseHistoryById(id);
    if (model != null) {
      model.status = status;
      model.actualTime = actualTime;
      try {
        await remoteDataSource.updateDoseHistory(model.id, model);
        await localDataSource.saveDoseHistory(model);
      } catch (e) {
        await localDataSource.saveDoseHistory(model);
        rethrow;
      }
    }
  }

  @override
  Future<void> deleteDoseHistoriesForSchedule(String scheduleId) async {
    try {
      // Typically the API handles this via schedule deletion cascade, but we can call it if available
      await localDataSource.deleteDoseHistoriesForSchedule(scheduleId);
    } catch (e) {
      await localDataSource.deleteDoseHistoriesForSchedule(scheduleId);
      rethrow;
    }
  }
}
