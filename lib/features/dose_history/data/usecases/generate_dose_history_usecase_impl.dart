import '../../domain/entities/dose_history.dart';
import '../../../schedule/domain/entities/schedule.dart';
import '../../domain/usecases/generate_dose_history_usecase.dart';
import 'package:uuid/uuid.dart';

class GenerateDoseHistoryUseCaseImpl implements GenerateDoseHistoryUseCase {
  final _uuid = const Uuid();

  @override
  Future<List<DoseHistory>> call({
    required Schedule schedule,
    required DateTime from,
    required DateTime to,
  }) async {
    List<DoseHistory> histories = [];

    // All dates here must be evaluated in UTC to prevent daylight saving bugs
    // before translating back to the user's localized DoseHistory view.
    
    DateTime current = schedule.startDate;
    
    // Ensure we start generating from the requested 'from' threshold
    // We compare just the dates, or ignore the exact time so it generates the first day even if creation happens late in the day
    if (current.isBefore(DateTime(from.year, from.month, from.day))) {
       current = from; 
    }

    final effectiveEndDate = schedule.endDate != null && schedule.endDate!.isBefore(to) 
        ? schedule.endDate! 
        : to;

    while (current.isBefore(effectiveEndDate) || current.isAtSameMomentAs(effectiveEndDate)) {
      
      // Calculate the exact target time for this specific day (evaluating as Local to respect User's timezone)
      final scheduledTarget = DateTime(
        current.year, 
        current.month, 
        current.day, 
        schedule.reminderTime.hour, 
        schedule.reminderTime.minute,
      );

      bool shouldAdd = false;

      switch (schedule.repeatType) {
        case RepeatType.daily:
          shouldAdd = true;
          break;
        case RepeatType.weekly:
          // Just as an example, assume 7 day jumps
          if (current.difference(schedule.startDate).inDays % 7 == 0) {
            shouldAdd = true;
          }
          break;
        case RepeatType.monthly:
          if (current.day == schedule.startDate.day) {
            shouldAdd = true;
          }
          break;
        case RepeatType.custom:
          if (schedule.customRepeatDays?.contains(current.weekday) ?? false) {
            shouldAdd = true;
          }
          break;
        case RepeatType.none:
          if (current.year == schedule.startDate.year && 
              current.month == schedule.startDate.month && 
              current.day == schedule.startDate.day) {
            shouldAdd = true;
          }
          break;
      }

      if (shouldAdd) {
        histories.add(DoseHistory(
          id: _uuid.v4(),
          scheduleId: schedule.id,
          medicineId: schedule.medicineId,
          userId: schedule.userId,
          scheduledTime: scheduledTarget,
          status: DoseStatus.scheduled,
        ));
      }
      
      current = current.add(const Duration(days: 1));
    }

    return histories;
  }
}
