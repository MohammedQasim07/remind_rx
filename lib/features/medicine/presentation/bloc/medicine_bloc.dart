import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_service.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';
import '../../../schedule/domain/entities/schedule.dart';
import '../../../dose_history/domain/repositories/dose_history_repository.dart';
import '../../../dose_history/domain/usecases/generate_dose_history_usecase.dart';

import 'medicine_event.dart';
import 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;
  final ScheduleRepository? scheduleRepository;
  final NotificationService? notificationService;
  final DoseHistoryRepository? doseHistoryRepository;
  final GenerateDoseHistoryUseCase? generateDoseHistoryUseCase;

  MedicineBloc({
    required this.repository,
    this.scheduleRepository,
    this.notificationService,
    this.doseHistoryRepository,
    this.generateDoseHistoryUseCase,
  }) : super(MedicineInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<AddMedicine>(_onAddMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
    on<UpdateMedicine>(_onUpdateMedicine);
    on<SaveCompleteMedicineBundle>(_onSaveCompleteMedicineBundle);
    on<RescheduleAllAlarms>(_onRescheduleAllAlarms);
  }

  Future<void> _onRescheduleAllAlarms(RescheduleAllAlarms event, Emitter<MedicineState> emit) async {
    if (scheduleRepository == null || notificationService == null) return;
    
    try {
      final medicines = await repository.getMedicinesForUser(event.userId);
      for (var medicine in medicines) {
        final schedules = await scheduleRepository!.getSchedulesForMedicine(medicine.id);
        for (var schedule in schedules) {
          final now = DateTime.now();
          final alarmTime = DateTime(
            now.year, now.month, now.day,
            schedule.reminderTime.hour,
            schedule.reminderTime.minute,
          );
          
          await notificationService!.scheduleMedicineAlarm(
            schedule: schedule,
            medicine: medicine,
            localAlarmTime: alarmTime,
          );
        }
      }
    } catch (e) {
      print('Rescheduling failed: $e');
    }
  }

  Future<void> _onLoadMedicines(LoadMedicines event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    try {
      final medicines = await repository.getMedicinesForUser(event.userId);
      emit(MedicineLoaded(medicines));
    } catch (e) {
      emit(MedicineError('Failed to load medicines: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateMedicine(UpdateMedicine event, Emitter<MedicineState> emit) async {
    try {
      if (state is MedicineLoaded) {
        emit(MedicineLoading());
        await repository.updateMedicine(event.medicine);
        final updatedList = await repository.getMedicinesForUser(event.medicine.userId ?? '');
        emit(MedicineLoaded(updatedList));
      }
    } catch (e) {
      emit(MedicineError('Failed to update medicine: ${e.toString()}'));
    }
  }

  Future<void> _onAddMedicine(AddMedicine event, Emitter<MedicineState> emit) async {
    try {
      if (state is MedicineLoaded) {
         emit(MedicineLoading());
         await repository.saveMedicine(event.medicine);
         // Reload after adding
         final updatedList = await repository.getMedicinesForUser(event.medicine.userId ?? '');
         emit(MedicineLoaded(updatedList));
       }
     } catch (e) {
       emit(MedicineError('Failed to add medicine: ${e.toString()}'));
     }
  }

  // Unit of Work: Save Med, Save Schedules, Register Notifications
  Future<void> _onSaveCompleteMedicineBundle(SaveCompleteMedicineBundle event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading()); // Blocks UI immediately
    try {
      // 1. Save Medicine
      await repository.saveMedicine(event.medicine);

      // 2. Save Schedules & Register Alarms if dependencies exist
      if (scheduleRepository != null && notificationService != null) {
        for (var rawSchedule in event.schedules) {
          if (rawSchedule is Schedule) {
            // Save to Local DB
            await scheduleRepository!.saveSchedule(rawSchedule);

            // GENERATE DOSE HISTORIES FOR DASHBOARD (Next 30 Days)
            if (doseHistoryRepository != null && generateDoseHistoryUseCase != null) {
              final generationNow = DateTime.now();
              final generationEnd = generationNow.add(const Duration(days: 30));
              final histories = await generateDoseHistoryUseCase!(
                schedule: rawSchedule,
                from: generationNow,
                to: generationEnd,
              );
              await doseHistoryRepository!.saveManyDoseHistories(histories);
            }

            // Register with OS Local Notifications
            // Extract local alarm time cleanly.
            final DateTime now = DateTime.now();
            final DateTime alarmTime = DateTime(
              now.year, now.month, now.day, 
              rawSchedule.reminderTime.hour, 
              rawSchedule.reminderTime.minute
            );
            
            await notificationService!.scheduleMedicineAlarm(
              schedule: rawSchedule,
              medicine: event.medicine,
              localAlarmTime: alarmTime,
            );
          }
        }
      }

      // 3. Success: Reload state
      final updatedList = await repository.getMedicinesForUser(event.medicine.userId ?? '');
      emit(MedicineLoaded(updatedList));
      
    } catch (e) {
      // If something fails, send explicit error. The UI will catch this and keep the form OPEN.
      emit(MedicineError('Atomic save failed: ${e.toString()}'));
      
      // Rollback logic could be implemented here (e.g. tracking written schedules and deleting them)
    }
  }

  Future<void> _onDeleteMedicine(DeleteMedicine event, Emitter<MedicineState> emit) async {
     try {
       if (state is MedicineLoaded) {
         final currentMedicines = (state as MedicineLoaded).medicines;
         final deletedIdx = currentMedicines.indexWhere((m) => m.id == event.medicineId);
         if (deletedIdx != -1) {
           final userId = currentMedicines[deletedIdx].userId;
           emit(MedicineLoading());
           
           // 1. Delete associated schedules and dose histories
           if (scheduleRepository != null && doseHistoryRepository != null) {
              final schedules = await scheduleRepository!.getSchedulesForMedicine(event.medicineId);
              for (var s in schedules) {
                 await doseHistoryRepository!.deleteDoseHistoriesForSchedule(s.id);
                 await scheduleRepository!.deleteSchedule(s.id);
              }
           }

           // 2. Delete medicine
           await repository.deleteMedicine(event.medicineId);
           
           final updatedList = await repository.getMedicinesForUser(userId ?? '');
           emit(MedicineLoaded(updatedList));
         }
       }
    } catch (e) {
      emit(MedicineError('Failed to delete medicine: ${e.toString()}'));
    }
  }
}
