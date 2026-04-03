import 'package:equatable/equatable.dart';
import '../../../../features/dose_history/domain/entities/dose_history.dart';
import '../../../../features/medicine/domain/entities/medicine.dart';

class DashboardDoseItem extends Equatable {
  final DoseHistory history;
  final Medicine medicine;

  const DashboardDoseItem({
    required this.history,
    required this.medicine,
  });

  @override
  List<Object?> get props => [history, medicine];
}

abstract class DashboardSummaryState extends Equatable {
  const DashboardSummaryState();

  @override
  List<Object?> get props => [];
}

class DashboardSummaryInitial extends DashboardSummaryState {}

class DashboardSummaryLoading extends DashboardSummaryState {}

class DashboardSummaryLoaded extends DashboardSummaryState {
  final List<DashboardDoseItem> doseItems;
  final int totalDoses;
  final int takenDoses;
  final int pendingDoses;

  const DashboardSummaryLoaded({
    required this.doseItems,
    required this.totalDoses,
    required this.takenDoses,
    required this.pendingDoses,
  });

  @override
  List<Object?> get props => [doseItems, totalDoses, takenDoses, pendingDoses];
}

class DashboardSummaryError extends DashboardSummaryState {
  final String message;

  const DashboardSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
