import '../../domain/entities/dose_history.dart';
import '../../domain/entities/schedule.dart';
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
    if (current.isBefore(from)) {
       current = from; 
    }

    final effectiveEndDate = schedule.endDate != null && schedule.endDate!.isBefore(to) 
        ? schedule.endDate! 
        : to;

    while (current.isBefore(effectiveEndDate) || current.isAtSameMomentAs(effectiveEndDate)) {
      
      // Calculate the exact target time for this specific day based on the reminderTime conceptually
      final scheduledTarget = DateTime.utc(
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
