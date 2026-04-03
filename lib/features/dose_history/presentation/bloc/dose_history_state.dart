import 'package:equatable/equatable.dart';
import '../../domain/entities/dose_history.dart';

abstract class DoseHistoryState extends Equatable {
  const DoseHistoryState();

  @override
  List<Object?> get props => [];
}

class DoseHistoryInitial extends DoseHistoryState {}

class DoseHistoryLoading extends DoseHistoryState {}

class DoseHistoryLoaded extends DoseHistoryState {
  final List<DoseHistory> dailyHistory;
  
  const DoseHistoryLoaded(this.dailyHistory);

  @override
  List<Object?> get props => [dailyHistory];

  // Helper getters for dashboard
  int get takenCount => dailyHistory.where((h) => h.status == DoseStatus.taken).length;
  int get pendingCount => dailyHistory.where((h) => h.status == DoseStatus.scheduled).length;
}

class DoseHistoryError extends DoseHistoryState {
  final String message;
  const DoseHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
