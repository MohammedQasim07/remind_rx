enum RepeatType { daily, weekly, monthly, custom, none }

abstract class Schedule {
  final String id;
  final String medicineId;
  final String userId;
  
  /// Stored in UTC. Represents the date the schedule begins.
  final DateTime startDate;
  
  /// Stored in UTC. Null implies the schedule runs indefinitely.
  final DateTime? endDate; 
  
  /// Stored in UTC conceptually, representing the target time. 
  /// UI layer must convert this to local time for display and exact alarm scheduling.
  final DateTime reminderTime; 
  
  final RepeatType repeatType;
  
  /// For custom repeat (e.g. Mon, Wed, Fri), uses DateTime.monday etc (1-7).
  final List<int>? customRepeatDays; 

  const Schedule({
    required this.id,
    required this.medicineId,
    required this.userId,
    required this.startDate,
    this.endDate,
    required this.reminderTime,
    required this.repeatType,
    this.customRepeatDays,
  });
}
