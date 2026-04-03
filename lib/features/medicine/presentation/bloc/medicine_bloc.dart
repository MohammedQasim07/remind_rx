import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/medicine_repository.dart';
import 'medicine_event.dart';
import 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;

  MedicineBloc({required this.repository}) : super(MedicineInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<AddMedicine>(_onAddMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
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

   Future<void> _onDeleteMedicine(DeleteMedicine event, Emitter<MedicineState> emit) async {
     try {
       if (state is MedicineLoaded) {
         final currentMedicines = (state as MedicineLoaded).medicines;
         // Check if we have the userId to reload, or just filter it out locally.
         // For robustness, find user id from current list
         final deletedIdx = currentMedicines.indexWhere((m) => m.id == event.medicineId);
         if (deletedIdx != -1) {
           final userId = currentMedicines[deletedIdx].userId;
           emit(MedicineLoading());
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
