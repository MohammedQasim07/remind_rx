import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_data_source.dart';
import '../models/medicine_model.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource localDataSource;

  MedicineRepositoryImpl(this.localDataSource);

  @override
  Future<Medicine?> getMedicineById(String id) async {
    final model = await localDataSource.getMedicineById(id);
    return model?.toEntity();
  }

  @override
  Future<List<Medicine>> getMedicinesForUser(String userId) async {
    final models = await localDataSource.getMedicinesForUser(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    final model = MedicineModel.fromEntity(medicine);
    await localDataSource.saveMedicine(model);
  }

  @override
  Future<void> updateMedicine(Medicine medicine) async {
    await saveMedicine(medicine);
  }

  @override
  Future<void> deleteMedicine(String id) async {
    await localDataSource.deleteMedicine(id);
  }
}
