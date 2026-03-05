import '../models/schedule_model.dart';
import 'package:isar/isar.dart';

abstract class ScheduleLocalDataSource {
  Future<ScheduleModel?> getScheduleById(String id);
  Future<List<ScheduleModel>> getSchedulesForMedicine(String medicineId);
  Future<List<ScheduleModel>> getSchedulesForUser(String userId);
  Future<void> saveSchedule(ScheduleModel schedule);
  Future<void> deleteSchedule(String id);
}

class ScheduleLocalDataSourceImpl implements ScheduleLocalDataSource {
  final Isar isar;

  ScheduleLocalDataSourceImpl(this.isar);

  @override
  Future<ScheduleModel?> getScheduleById(String id) async {
    return await isar.scheduleModels.filter().idEqualTo(id).findFirst();
  }

  @override
  Future<List<ScheduleModel>> getSchedulesForMedicine(String medicineId) async {
    return await isar.scheduleModels.filter().medicineIdEqualTo(medicineId).findAll();
  }

  @override
  Future<List<ScheduleModel>> getSchedulesForUser(String userId) async {
    return await isar.scheduleModels.filter().userIdEqualTo(userId).findAll();
  }

  @override
  Future<void> saveSchedule(ScheduleModel schedule) async {
    await isar.writeTxn(() async {
      await isar.scheduleModels.put(schedule);
    });
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await isar.writeTxn(() async {
      final schedule = await getScheduleById(id);
      if (schedule != null) {
        await isar.scheduleModels.delete(schedule.isarId);
      }
    });
  }
}
