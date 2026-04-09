import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_service.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';
import '../../../schedule/domain/entities/schedule.dart';

import 'medicine_event.dart';
import 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;
  final ScheduleRepository? scheduleRepository;
  final NotificationService? notificationService;

  MedicineBloc({
    required this.repository,
    this.scheduleRepository,
    this.notificationService,
  }) : super(MedicineInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<AddMedicine>(_onAddMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
    on<UpdateMedicine>(_onUpdateMedicine);
    on<SaveCompleteMedicineBundle>(_onSaveCompleteMedicineBundle);
  }

  Future<void> _onLoadMedicines(LoadMedicines event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    try {
      final medicines = await repository.getMedicinesForUser(event.userId);
      emit(MedicineLoaded(medicines));
    } catch (e) {
      emit(MedicineError('Failed to load medicines: \${e.toString()}'));
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
      emit(MedicineError('Failed to update medicine: \${e.toString()}'));
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
       emit(MedicineError('Failed to add medicine: \${e.toString()}'));
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
      emit(MedicineError('Atomic save failed: \${e.toString()}'));
      
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
           
           // Theoretically we should also cancel the raw OS notifications tied to this medicine here
           // For now, delete from DB.
           await repository.deleteMedicine(event.medicineId);
           
           final updatedList = await repository.getMedicinesForUser(userId ?? '');
           emit(MedicineLoaded(updatedList));
         }
       }
    } catch (e) {
      emit(MedicineError('Failed to delete medicine: \${e.toString()}'));
    }
  }
}
