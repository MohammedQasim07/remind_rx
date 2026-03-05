enum DoseStatus { scheduled, taken, missed, skipped }

abstract class DoseHistory {
  final String id;
  final String scheduleId;
  final String medicineId;
  final String userId;
  
  /// Stored in UTC. Exact scheduled time for this specific dose.
  final DateTime scheduledTime;
  
  /// Stored in UTC. The actual time the dose was taken/missed. Null if still scheduled.
  final DateTime? actualTime;
  
  final DoseStatus status;

  const DoseHistory({
    required this.id,
    required this.scheduleId,
    required this.medicineId,
    required this.userId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
  });
}
