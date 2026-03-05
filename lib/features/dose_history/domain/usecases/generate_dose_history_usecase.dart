import '../entities/dose_history.dart';
import '../../schedule/domain/entities/schedule.dart';

abstract class GenerateDoseHistoryUseCase {
  /// Evaluates a `Schedule` and generates `DoseHistory` entities for a specific time window.
  /// This is critical for offline-first architecture, allowing the app to pre-generate
  /// the required models locally without requiring backend connectivity.
  /// 
  /// The [from] and [to] dates should ideally be passed in UTC.
  Future<List<DoseHistory>> call({
    required Schedule schedule, 
    required DateTime from, 
    required DateTime to,
  });
}
