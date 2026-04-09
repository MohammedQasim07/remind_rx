import 'package:json_annotation/json_annotation.dart';

enum MedicineType {
  @JsonValue(0) pill,
  @JsonValue(1) capsule,
  @JsonValue(2) liquid,
  @JsonValue(3) injection,
  @JsonValue(4) inhaler,
  @JsonValue(5) drops,
  @JsonValue(6) cream,
  @JsonValue(7) other
}

enum MedicineStatus {
  @JsonValue(0) active,
  @JsonValue(1) inactive,
  @JsonValue(2) completed,
  @JsonValue(3) deleted
}

class Medicine {
  final String id;
  final String? userId; // Nullable if not logged in
  final String name;
  final String? description;
  final double dosageAmount;
  final String? dosageUnit;
  final MedicineType type;
  final MedicineStatus status;
  final int frequencyPerDay;
  final int stockQuantity;
  final int lowStockThreshold;
  final String? notes;

  const Medicine({
    required this.id,
    this.userId,
    required this.name,
    this.description,
    required this.dosageAmount,
    this.dosageUnit,
    required this.type,
    required this.status,
    required this.frequencyPerDay,
    required this.stockQuantity,
    required this.lowStockThreshold,
    this.notes,
  });

  Medicine copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? dosageAmount,
    String? dosageUnit,
    MedicineType? type,
    MedicineStatus? status,
    int? frequencyPerDay,
    int? stockQuantity,
    int? lowStockThreshold,
    String? notes,
  }) {
    return Medicine(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      dosageAmount: dosageAmount ?? this.dosageAmount,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      type: type ?? this.type,
      status: status ?? this.status,
      frequencyPerDay: frequencyPerDay ?? this.frequencyPerDay,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      notes: notes ?? this.notes,
    );
  }
}
