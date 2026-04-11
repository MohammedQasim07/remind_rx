import '../models/dose_history_model.dart';
import 'package:isar/isar.dart';

abstract class DoseHistoryLocalDataSource {
  Future<DoseHistoryModel?> getDoseHistoryById(String id);
  Future<List<DoseHistoryModel>> getDoseHistoryForSchedule(String scheduleId);
  Future<List<DoseHistoryModel>> getDoseHistoryForUser(String userId, DateTime from, DateTime to);
  Future<void> saveDoseHistory(DoseHistoryModel history);
  Future<void> saveManyDoseHistories(List<DoseHistoryModel> histories);
  Future<void> deleteDoseHistoriesForSchedule(String scheduleId);
}

class DoseHistoryLocalDataSourceImpl implements DoseHistoryLocalDataSource {
  final Isar isar;

  DoseHistoryLocalDataSourceImpl(this.isar);

  @override
  Future<DoseHistoryModel?> getDoseHistoryById(String id) async {
    return await isar.doseHistoryModels.filter().idEqualTo(id).findFirst();
  }

  @override
  Future<List<DoseHistoryModel>> getDoseHistoryForSchedule(String scheduleId) async {
    return await isar.doseHistoryModels.filter().scheduleIdEqualTo(scheduleId).findAll();
  }

  @override
  Future<List<DoseHistoryModel>> getDoseHistoryForUser(String userId, DateTime from, DateTime to) async {
    return await isar.doseHistoryModels.filter()
        .userIdEqualTo(userId)
        .and()
        .scheduledTimeBetween(from, to)
        .findAll();
  }

  @override
  Future<void> saveDoseHistory(DoseHistoryModel history) async {
    await isar.writeTxn(() async {
      await isar.doseHistoryModels.put(history);
    });
  }

  @override
  Future<void> saveManyDoseHistories(List<DoseHistoryModel> histories) async {
    await isar.writeTxn(() async {
      await isar.doseHistoryModels.putAll(histories);
    });
  }

  @override
  Future<void> deleteDoseHistoriesForSchedule(String scheduleId) async {
    await isar.writeTxn(() async {
      await isar.doseHistoryModels.filter().scheduleIdEqualTo(scheduleId).deleteAll();
    });
  }
}
