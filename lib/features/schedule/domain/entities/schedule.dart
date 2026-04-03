import 'package:json_annotation/json_annotation.dart';

enum RepeatType {
  @JsonValue(0) daily,
  @JsonValue(1) weekly,
  @JsonValue(2) monthly,
  @JsonValue(3) custom,
  @JsonValue(4) none
}

class Schedule {
  final String id;
  final String medicineId;
  final String? userId; // Optional for remote sync
  
  final DateTime startDate;
  final DateTime? endDate; 
  final DateTime reminderTime; 
  final RepeatType repeatType;
  
  final int? repeatInterval;
  final String? daysOfWeek; // For weekly/custom, e.g. "1,3,5"
  final List<int>? customRepeatDays;
  final bool isActive;
  final String? notes;

  const Schedule({
    required this.id,
    required this.medicineId,
    this.userId,
    required this.startDate,
    this.endDate,
    required this.reminderTime,
    required this.repeatType,
    this.repeatInterval,
    this.daysOfWeek,
    this.customRepeatDays,
    this.isActive = true,
    this.notes,
  });
}
