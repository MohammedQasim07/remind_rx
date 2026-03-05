enum MedicineType { pill, capsule, liquid, injection, inhaler, drops, other }
enum MedicineStatus { active, inactive }

abstract class Medicine {
  final String id;
  final String userId;
  final String name;
  final double dosage;
  final MedicineType type;
  final MedicineStatus status;
  final String frequency; // e.g., "Twice a day". The exact rules go in Schedule.
  final int stock;
  final int lowStockThreshold;

  const Medicine({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.type,
    required this.status,
    required this.frequency,
    required this.stock,
    required this.lowStockThreshold,
  });
}
