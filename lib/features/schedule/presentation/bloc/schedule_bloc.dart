import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../../dose_history/domain/repositories/dose_history_repository.dart';
import '../../../dose_history/domain/usecases/generate_dose_history_usecase.dart';
import '../../../../core/services/notification_service.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository scheduleRepository;
  final DoseHistoryRepository doseHistoryRepository;
  final GenerateDoseHistoryUseCase generateDoseHistoryUseCase;
  final NotificationService notificationService;

  ScheduleBloc({
    required this.scheduleRepository,
    required this.doseHistoryRepository,
    required this.generateDoseHistoryUseCase,
    required this.notificationService,
  }) : super(ScheduleInitial()) {
    on<LoadSchedules>(_onLoadSchedules);
    on<AddSchedule>(_onAddSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
  }

  Future<void> _onLoadSchedules(LoadSchedules event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedules = await scheduleRepository.getSchedulesForUser(event.userId);
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onAddSchedule(AddSchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      // 1. Save Schedule to Repository (Syncs to Cloud/Local)
      await scheduleRepository.saveSchedule(event.schedule);

      // 2. Generate Dose History for the next 30 days
      final now = DateTime.now();
      final end = now.add(const Duration(days: 30));
      final histories = await generateDoseHistoryUseCase(
        schedule: event.schedule,
        from: now,
        to: end,
      );

      // 3. Save Generated Histories
      for (var history in histories) {
        await doseHistoryRepository.saveDoseHistory(history);
        
        // 4. Schedule Local Notification for each dose
        // (Simplified for now - Daily repeats can be handled as one recurring alarm)
      }
      
      // Handle the first alarm or daily recurring alarm
      await notificationService.scheduleMedicineAlarm(
        schedule: event.schedule,
        medicine: event.medicine,
        localAlarmTime: DateTime(
          now.year, now.month, now.day,
          event.schedule.reminderTime.hour,
          event.schedule.reminderTime.minute,
        ),
      );

      // Reload schedules
      final schedules = await scheduleRepository.getSchedulesForUser(event.schedule.userId!);
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(DeleteSchedule event, Emitter<ScheduleState> emit) async {
    // Implement delete logic and cancel notifications
    try {
      await scheduleRepository.deleteSchedule(event.scheduleId);
      // notificationService.cancelAllAlarms(); // Or specific ID
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
