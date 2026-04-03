import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/medicine.dart';

part 'medicine_model.g.dart';

@collection
@JsonSerializable()
class MedicineModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  String? userId;

  late String name;
  String? description;
  
  @JsonKey(name: 'dosageAmount')
  late double dosageAmount;
  
  String? dosageUnit;
  
  @enumerated
  late MedicineType type;
  
  @enumerated
  late MedicineStatus status;

  @JsonKey(name: 'frequencyPerDay')
  late int frequencyPerDay;
  
  @JsonKey(name: 'stockQuantity')
  late int stockQuantity;
  
  late int lowStockThreshold;
  String? notes;

  MedicineModel();

  factory MedicineModel.fromJson(Map<String, dynamic> json) => _$MedicineModelFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineModelToJson(this);

  factory MedicineModel.fromEntity(Medicine medicine) {
    return MedicineModel()
      ..id = medicine.id
      ..userId = medicine.userId
      ..name = medicine.name
      ..description = medicine.description
      ..dosageAmount = medicine.dosageAmount
      ..dosageUnit = medicine.dosageUnit
      ..type = medicine.type
      ..status = medicine.status
      ..frequencyPerDay = medicine.frequencyPerDay
      ..stockQuantity = medicine.stockQuantity
      ..lowStockThreshold = medicine.lowStockThreshold
      ..notes = medicine.notes;
  }

  Medicine toEntity() {
    return _MedicineImpl(
      id: id,
      userId: userId,
      name: name,
      description: description,
      dosageAmount: dosageAmount,
      dosageUnit: dosageUnit,
      type: type,
      status: status,
      frequencyPerDay: frequencyPerDay,
      stockQuantity: stockQuantity,
      lowStockThreshold: lowStockThreshold,
      notes: notes,
    );
  }
}

class _MedicineImpl extends Medicine {
  const _MedicineImpl({
    required super.id,
    super.userId,
    required super.name,
    super.description,
    required super.dosageAmount,
    super.dosageUnit,
    required super.type,
    required super.status,
    required super.frequencyPerDay,
    required super.stockQuantity,
    required super.lowStockThreshold,
    super.notes,
  });
}
