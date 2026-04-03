import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/dose_history/domain/repositories/dose_history_repository.dart';
import '../../../../features/medicine/domain/repositories/medicine_repository.dart';
import 'dashboard_summary_event.dart';
import 'dashboard_summary_state.dart';
import '../../../../features/dose_history/domain/entities/dose_history.dart';

class DashboardSummaryBloc extends Bloc<DashboardSummaryEvent, DashboardSummaryState> {
  final DoseHistoryRepository doseHistoryRepository;
  final MedicineRepository medicineRepository;

  DashboardSummaryBloc({
    required this.doseHistoryRepository,
    required this.medicineRepository,
  }) : super(DashboardSummaryInitial()) {
    on<LoadDashboardSummary>(_onLoadDashboardSummary);
    on<MarkDoseStatus>(_onMarkDoseStatus);
  }

  Future<void> _onLoadDashboardSummary(LoadDashboardSummary event, Emitter<DashboardSummaryState> emit) async {
    emit(DashboardSummaryLoading());
    try {
      final startOfDay = DateTime(event.date.year, event.date.month, event.date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

      // Fetch dose history for today
      final histories = await doseHistoryRepository.getDoseHistoryForUser(event.userId, startOfDay, endOfDay);
      
      // Fetch medicines to map details
      final medicines = await medicineRepository.getMedicinesForUser(event.userId);
      final medicineMap = {for (var m in medicines) m.id: m};

      final List<DashboardDoseItem> items = [];
      int total = histories.length;
      int taken = 0;
      int pending = 0;

      for (var history in histories) {
        if (history.status == DoseStatus.taken) taken++;
        if (history.status == DoseStatus.scheduled || history.status == DoseStatus.missed) pending++;

        final medicine = medicineMap[history.medicineId];
        if (medicine != null) {
          items.add(DashboardDoseItem(history: history, medicine: medicine));
        }
      }

      // Sort chronological
      items.sort((a, b) => a.history.scheduledTime.compareTo(b.history.scheduledTime));

      emit(DashboardSummaryLoaded(
        doseItems: items,
        totalDoses: total,
        takenDoses: taken,
        pendingDoses: pending,
      ));
    } catch (e) {
      emit(DashboardSummaryError(e.toString()));
    }
  }

  Future<void> _onMarkDoseStatus(MarkDoseStatus event, Emitter<DashboardSummaryState> emit) async {
    try {
      await doseHistoryRepository.updateDoseHistoryStatus(
        event.historyId,
        event.status,
        event.actualTime,
      );
      // We rely on UI to re-dispatch LoadDashboardSummary immediately to refresh.
    } catch (e) {
      // In a more complex setup, we'd emit a side-effect error here.
    }
  }
}
