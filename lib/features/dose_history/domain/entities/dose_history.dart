import 'package:json_annotation/json_annotation.dart';

enum DoseStatus {
  @JsonValue(0) scheduled,
  @JsonValue(1) taken,
  @JsonValue(2) missed,
  @JsonValue(3) skipped
}

class DoseHistory {
  final String id;
  final String scheduleId;
  final String medicineId;
  final String? userId;
  
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final DoseStatus status;
  final String? notes;

  const DoseHistory({
    required this.id,
    required this.scheduleId,
    required this.medicineId,
    this.userId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    this.notes,
  });
}
