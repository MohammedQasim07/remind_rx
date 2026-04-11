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
    final localModels = await localDataSource.getDoseHistoryForSchedule(scheduleId);
    if (localModels.isNotEmpty) {
      _backgroundSyncSchedule(scheduleId);
      return localModels.map((m) => m.toEntity()).toList();
    }
    try {
      final remoteModels = await remoteDataSource.getDoseHistory(medicineId: scheduleId);
      await localDataSource.saveManyDoseHistories(remoteModels);
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      return localModels.map((m) => m.toEntity()).toList();
    }
  }

  void _backgroundSyncSchedule(String scheduleId) async {
    try {
       final remoteModels = await remoteDataSource.getDoseHistory(medicineId: scheduleId);
       await localDataSource.saveManyDoseHistories(remoteModels);
    } catch (_) {}
  }

  @override
  Future<List<DoseHistory>> getDoseHistoryForUser(String userId, DateTime from, DateTime to) async {
    final localModels = await localDataSource.getDoseHistoryForUser(userId, from, to);
    if (localModels.isNotEmpty) {
      _backgroundSyncUser(userId);
      return localModels.map((m) => m.toEntity()).toList();
    }
    try {
      final remoteModels = await remoteDataSource.getDoseHistory(userId: userId);
      await localDataSource.saveManyDoseHistories(remoteModels);
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      return localModels.map((m) => m.toEntity()).toList();
    }
  }

  void _backgroundSyncUser(String userId) async {
    try {
       final remoteModels = await remoteDataSource.getDoseHistory(userId: userId);
       await localDataSource.saveManyDoseHistories(remoteModels);
    } catch (_) {}
  }

  @override
  Future<void> saveDoseHistory(DoseHistory history) async {
    final model = DoseHistoryModel.fromEntity(history);
    try {
      await remoteDataSource.createDoseHistory(model);
      await localDataSource.saveDoseHistory(model);
    } catch (e) {
      // Offline fallback: log and proceed
      print('Network Error saving dose history, syncing later: $e');
      await localDataSource.saveDoseHistory(model);
    }
  }

  @override
  Future<void> saveManyDoseHistories(List<DoseHistory> histories) async {
    final models = histories.map((e) => DoseHistoryModel.fromEntity(e)).toList();
    
    // 1. Instantly save all to local DB to keep the UI blazingly fast
    await localDataSource.saveManyDoseHistories(models);
    
    // 2. Fire and forget remote creation asynchronously so user doesn't wait
    Future.wait(models.map((model) async {
      try {
        await remoteDataSource.createDoseHistory(model);
      } catch (e) {
        print('Background Sync Error creating dose: $e');
      }
    }));
  }

  @override
  Future<void> updateDoseHistoryStatus(String id, DoseStatus status, DateTime? actualTime) async {
    final model = await localDataSource.getDoseHistoryById(id);
    if (model != null && model.status != status) {
      model.status = status;
      model.actualTime = actualTime;
      // Instantly save to local DB
      await localDataSource.saveDoseHistory(model);
      
      // Background sync to remote
      remoteDataSource.updateDoseHistory(model.id, model).catchError((e) {
        print('Network Error updating dose history sync: $e');
      });
    }
  }

  @override
  Future<void> deleteDoseHistoriesForSchedule(String scheduleId) async {
    try {
      // Typically the API handles this via schedule deletion cascade, but we can call it if available
      await localDataSource.deleteDoseHistoriesForSchedule(scheduleId);
    } catch (e) {
      print('Error deleting local dose histories: $e');
      await localDataSource.deleteDoseHistoriesForSchedule(scheduleId);
    }
  }
}
