import 'package:equatable/equatable.dart';
import '../../domain/entities/dose_history.dart';

abstract class DoseHistoryEvent extends Equatable {
  const DoseHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyDoseHistory extends DoseHistoryEvent {
  final String userId;
  final DateTime date;
  const LoadDailyDoseHistory(this.userId, this.date);

  @override
  List<Object?> get props => [userId, date];
}

class LoadWeeklyDoseHistory extends DoseHistoryEvent {
  final String userId;

  const LoadWeeklyDoseHistory(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateDoseStatus extends DoseHistoryEvent {
  final String historyId;
  final DoseStatus status;
  final DateTime? actualTime;
  const UpdateDoseStatus({
    required this.historyId,
    required this.status,
    this.actualTime,
  });

  @override
  List<Object?> get props => [historyId, status, actualTime];
}
