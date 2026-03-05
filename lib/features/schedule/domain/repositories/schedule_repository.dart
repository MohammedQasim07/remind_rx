import '../entities/schedule.dart';

abstract class ScheduleRepository {
  Future<Schedule?> getScheduleById(String id);
  Future<List<Schedule>> getSchedulesForMedicine(String medicineId);
  Future<List<Schedule>> getSchedulesForUser(String userId);
  Future<void> saveSchedule(Schedule schedule);
  Future<void> updateSchedule(Schedule schedule);
  Future<void> deleteSchedule(String id);
}
