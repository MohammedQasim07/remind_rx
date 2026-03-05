import '../models/medicine_model.dart';
import 'package:isar/isar.dart';

abstract class MedicineLocalDataSource {
  Future<MedicineModel?> getMedicineById(String id);
  Future<List<MedicineModel>> getMedicinesForUser(String userId);
  Future<void> saveMedicine(MedicineModel medicine);
  Future<void> deleteMedicine(String id);
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final Isar isar;

  MedicineLocalDataSourceImpl(this.isar);

  @override
  Future<MedicineModel?> getMedicineById(String id) async {
    return await isar.medicineModels.filter().idEqualTo(id).findFirst();
  }

  @override
  Future<List<MedicineModel>> getMedicinesForUser(String userId) async {
    return await isar.medicineModels.filter().userIdEqualTo(userId).findAll();
  }

  @override
  Future<void> saveMedicine(MedicineModel medicine) async {
    await isar.writeTxn(() async {
      await isar.medicineModels.put(medicine);
    });
  }

  @override
  Future<void> deleteMedicine(String id) async {
    await isar.writeTxn(() async {
      final medicine = await getMedicineById(id);
      if (medicine != null) {
        await isar.medicineModels.delete(medicine.isarId);
      }
    });
  }
}
