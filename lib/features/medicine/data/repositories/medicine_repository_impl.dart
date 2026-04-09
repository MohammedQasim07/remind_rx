import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_data_source.dart';
import '../datasources/medicine_remote_data_source.dart';
import '../models/medicine_model.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource localDataSource;
  final MedicineRemoteDataSource remoteDataSource;

  MedicineRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Medicine?> getMedicineById(String id) async {
    try {
      // Try to get from remote and update local
      final remoteModel = await remoteDataSource.getMedicineById(id);
      await localDataSource.saveMedicine(remoteModel);
      return remoteModel.toEntity();
    } catch (e) {
      // Fallback to local
      final model = await localDataSource.getMedicineById(id);
      return model?.toEntity();
    }
  }

  @override
  Future<List<Medicine>> getMedicinesForUser(String userId) async {
    try {
      // Fetch from remote and sync to local
      final remoteModels = await remoteDataSource.getMedicines(userId: userId);
      for (var model in remoteModels) {
        await localDataSource.saveMedicine(model);
      }
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      // Offline fallback
      final models = await localDataSource.getMedicinesForUser(userId);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    final model = MedicineModel.fromEntity(medicine);
    try {
      final payload = {
        "name": model.name,
        "description": model.description,
        "dosageAmount": model.dosageAmount,
        "dosageUnit": model.dosageUnit,
        "type": model.type.index, // Assuming API matches enum index
        "status": model.status.index,
        "frequencyPerDay": model.frequencyPerDay,
        "stockQuantity": model.stockQuantity,
        "lowStockThreshold": model.lowStockThreshold,
        "notes": model.notes,
        "userId": model.userId,
      };
      await remoteDataSource.createMedicine(payload);
      await localDataSource.saveMedicine(model);
    } catch (e) {
      // Offline-First Logic: Save locally, do not throw remote error to the user.
      print('Network Error saving medicine, syncing later: $e');
      await localDataSource.saveMedicine(model);
    }
  }

  @override
  Future<void> updateMedicine(Medicine medicine) async {
    final model = MedicineModel.fromEntity(medicine);
    try {
      final payload = {
        "name": model.name,
        "description": model.description,
        "dosageAmount": model.dosageAmount,
        "dosageUnit": model.dosageUnit,
        "type": model.type.index, 
        "status": model.status.index,
        "frequencyPerDay": model.frequencyPerDay,
        "stockQuantity": model.stockQuantity,
        "lowStockThreshold": model.lowStockThreshold,
        "notes": model.notes,
        "userId": model.userId,
      };
      await remoteDataSource.updateMedicine(model.id, payload);
      await localDataSource.saveMedicine(model);
    } catch (e) {
      print('Network Error updating medicine, syncing later: $e');
      await localDataSource.saveMedicine(model);
    }
  }

  @override
  Future<void> deleteMedicine(String id) async {
    try {
      await remoteDataSource.deleteMedicine(id);
      await localDataSource.deleteMedicine(id);
    } catch (e) {
      await localDataSource.deleteMedicine(id);
      rethrow;
    }
  }
}
