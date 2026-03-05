import '../entities/dose_history.dart';

abstract class DoseHistoryRepository {
  Future<DoseHistory?> getDoseHistoryById(String id);
  Future<List<DoseHistory>> getDoseHistoryForSchedule(String scheduleId);
  Future<List<DoseHistory>> getDoseHistoryForUser(String userId, DateTime from, DateTime to);
  Future<void> saveDoseHistory(DoseHistory history);
  Future<void> updateDoseHistoryStatus(String id, DoseStatus status, DateTime? actualTime);
  Future<void> deleteDoseHistoriesForSchedule(String scheduleId);
}
