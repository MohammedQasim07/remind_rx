import 'package:equatable/equatable.dart';
import '../../domain/entities/medicine.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object> get props => [];
}

class LoadMedicines extends MedicineEvent {
  final String userId;

  const LoadMedicines(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddMedicine extends MedicineEvent {
  final Medicine medicine;

  const AddMedicine(this.medicine);

  @override
  List<Object> get props => [medicine];
}

class DeleteMedicine extends MedicineEvent {
  final String medicineId;

  const DeleteMedicine(this.medicineId);

  @override
  List<Object> get props => [medicineId];
}
