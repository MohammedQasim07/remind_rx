import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/dose_history_repository.dart';
import 'dose_history_event.dart';
import 'dose_history_state.dart';

class DoseHistoryBloc extends Bloc<DoseHistoryEvent, DoseHistoryState> {
  final DoseHistoryRepository doseHistoryRepository;

  DoseHistoryBloc({required this.doseHistoryRepository}) : super(DoseHistoryInitial()) {
    on<LoadDailyDoseHistory>(_onLoadDailyDoseHistory);
    on<UpdateDoseStatus>(_onUpdateDoseStatus);
  }

  Future<void> _onLoadDailyDoseHistory(
    LoadDailyDoseHistory event,
    Emitter<DoseHistoryState> emit,
  ) async {
    emit(DoseHistoryLoading());
    try {
      final startOfDay = DateTime(event.date.year, event.date.month, event.date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
      
      final history = await doseHistoryRepository.getDoseHistoryForUser(event.userId, startOfDay, endOfDay);
      emit(DoseHistoryLoaded(history));
    } catch (e) {
      emit(DoseHistoryError(e.toString()));
    }
  }

  Future<void> _onUpdateDoseStatus(
    UpdateDoseStatus event,
    Emitter<DoseHistoryState> emit,
  ) async {
    try {
      await doseHistoryRepository.updateDoseHistoryStatus(
        event.historyId,
        event.status,
        event.actualTime,
      );
      
      // Simplify: reload is usually handled by the UI or by re-adding LoadDailyDoseHistory
    } catch (e) {
      emit(DoseHistoryError(e.toString()));
    }
  }
}
