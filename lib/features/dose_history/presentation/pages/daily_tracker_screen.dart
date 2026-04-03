import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dose_history.dart';
import '../bloc/dose_history_bloc.dart';
import '../bloc/dose_history_event.dart';
import '../bloc/dose_history_state.dart';
import '../../../medicine/presentation/bloc/medicine_bloc.dart';
import '../../../medicine/presentation/bloc/medicine_state.dart';
import '../../../../core/theme/app_theme.dart';

class DailyTrackerScreen extends StatelessWidget {
  final String userId;

  const DailyTrackerScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initial fetch
    context.read<DoseHistoryBloc>().add(LoadDailyDoseHistory(userId, DateTime.now()));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Daily Tracker'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.healthGradient,
          ),
        ),
      ),
      body: BlocBuilder<DoseHistoryBloc, DoseHistoryState>(
        builder: (context, state) {
          if (state is DoseHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DoseHistoryLoaded) {
            if (state.dailyHistory.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildDoseList(context, state.dailyHistory);
          } else if (state is DoseHistoryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 80, color: AppTheme.textGrey.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'No doses scheduled for today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 8),
          const Text('Your medication schedule will appear here', style: TextStyle(color: AppTheme.textGrey)),
        ],
      ),
    );
  }

  Widget _buildDoseList(BuildContext context, List<DoseHistory> history) {
     // Sort by time
    final sortedHistory = List<DoseHistory>.from(history)
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: sortedHistory.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = sortedHistory[index];
        return _buildDoseCard(context, item);
      },
    );
  }

  Widget _buildDoseCard(BuildContext context, DoseHistory dose) {
    // Cross-reference medicine details from MedicineBloc
    final medicineState = context.watch<MedicineBloc>().state;
    String medicineName = 'Loading...';
    String medicineDosage = '';

    if (medicineState is MedicineLoaded) {
      final medicine = medicineState.medicines.firstWhere(
        (m) => m.id == dose.medicineId,
        orElse: () => medicineState.medicines.first, // Fallback (shouldn't happen)
      );
      medicineName = medicine.name;
      medicineDosage = '${medicine.dosageAmount} ${medicine.dosageUnit ?? medicine.type.name}';
    }

    final isTaken = dose.status == DoseStatus.taken;
    final isMissed = dose.status == DoseStatus.missed;
    final timeStr = DateFormat('hh:mm a').format(dose.scheduledTime);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Time Side
          Column(
            children: [
              Text(
                timeStr,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryGreen),
              ),
              const SizedBox(height: 4),
              _buildStatusIndicator(dose.status),
            ],
          ),
          const SizedBox(width: 20),
          // Info Side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: isTaken ? TextDecoration.lineThrough : null,
                    color: isTaken ? AppTheme.textGrey : AppTheme.textDark,
                  ),
                ),
                Text(medicineDosage, style: const TextStyle(color: AppTheme.textGrey)),
              ],
            ),
          ),
          // Action Button
          if (!isTaken)
            ElevatedButton(
              onPressed: () => _markAsTaken(context, dose.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(80, 40),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Take'),
            )
          else
            const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 32),
        ],
      ),
      ),
    );
  }

  Widget _buildStatusIndicator(DoseStatus status) {
    Color color = Colors.grey;
    if (status == DoseStatus.taken) color = AppTheme.accentGreen;
    if (status == DoseStatus.missed) color = Colors.redAccent;
    if (status == DoseStatus.scheduled) color = AppTheme.primaryGreen;

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _markAsTaken(BuildContext context, String historyId) {
    context.read<DoseHistoryBloc>().add(
          UpdateDoseStatus(historyId: historyId, status: DoseStatus.taken, actualTime: DateTime.now()),
        );
  }
}
