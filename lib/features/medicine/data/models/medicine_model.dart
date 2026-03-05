import 'package:isar/isar.dart';
import '../../domain/entities/medicine.dart';

part 'medicine_model.g.dart';

@collection
class MedicineModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String userId;

  late String name;
  late double dosage;
  
  @enumerated
  late MedicineType type;
  
  @enumerated
  late MedicineStatus status;

  late String frequency;
  late int stock;
  late int lowStockThreshold;

  MedicineModel();

  factory MedicineModel.fromEntity(Medicine medicine) {
    return MedicineModel()
      ..id = medicine.id
      ..userId = medicine.userId
      ..name = medicine.name
      ..dosage = medicine.dosage
      ..type = medicine.type
      ..status = medicine.status
      ..frequency = medicine.frequency
      ..stock = medicine.stock
      ..lowStockThreshold = medicine.lowStockThreshold;
  }

  Medicine toEntity() {
    return _MedicineImpl(
      id: id,
      userId: userId,
      name: name,
      dosage: dosage,
      type: type,
      status: status,
      frequency: frequency,
      stock: stock,
      lowStockThreshold: lowStockThreshold,
    );
  }
}

class _MedicineImpl extends Medicine {
  const _MedicineImpl({
    required super.id,
    required super.userId,
    required super.name,
    required super.dosage,
    required super.type,
    required super.status,
    required super.frequency,
    required super.stock,
    required super.lowStockThreshold,
  });
}
