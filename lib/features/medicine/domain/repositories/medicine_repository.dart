import '../entities/medicine.dart';

abstract class MedicineRepository {
  Future<Medicine?> getMedicineById(String id);
  Future<List<Medicine>> getMedicinesForUser(String userId);
  Future<void> saveMedicine(Medicine medicine);
  Future<void> updateMedicine(Medicine medicine);
  Future<void> deleteMedicine(String id);
}
