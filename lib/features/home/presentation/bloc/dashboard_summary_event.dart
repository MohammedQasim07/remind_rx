import 'package:equatable/equatable.dart';
import '../../../../features/dose_history/domain/entities/dose_history.dart';

abstract class DashboardSummaryEvent extends Equatable {
  const DashboardSummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardSummary extends DashboardSummaryEvent {
  final String userId;
  final DateTime date;

  const LoadDashboardSummary({
    required this.userId,
    required this.date,
  });

  @override
  List<Object?> get props => [userId, date];
}

class MarkDoseStatus extends DashboardSummaryEvent {
  final String historyId;
  final DoseStatus status;
  final DateTime actualTime;

  const MarkDoseStatus({
    required this.historyId,
    required this.status,
    required this.actualTime,
  });

  @override
  List<Object?> get props => [historyId, status, actualTime];
}
