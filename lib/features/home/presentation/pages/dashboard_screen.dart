import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/dashboard_summary_bloc.dart';
import '../bloc/dashboard_summary_event.dart';
import '../bloc/dashboard_summary_state.dart';
import '../../../../features/dose_history/domain/entities/dose_history.dart';

class DashboardScreen extends StatefulWidget {
  final String currentUserId;

  const DashboardScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardSummaryBloc>().add(LoadDashboardSummary(
          userId: widget.currentUserId,
          date: DateTime.now(),
        ));
  }

  void _showDoseConfirmationDialog(DashboardDoseItem item) {
    if (item.history.status == DoseStatus.taken) return; // Already taken

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Mark Dose', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        content: Text('What would you like to do with ${item.medicine.name}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateDoseStatus(item, DoseStatus.skipped);
            },
            child: const Text('Skip Dose'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateDoseStatus(item, DoseStatus.taken);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: const Text('Mark as Taken'),
          ),
        ],
      ),
    );
  }

  void _updateDoseStatus(DashboardDoseItem item, DoseStatus newStatus) {
    context.read<DashboardSummaryBloc>().add(MarkDoseStatus(
          historyId: item.history.id,
          status: newStatus,
          actualTime: DateTime.now(),
        ));
    // Immediately reload
    context.read<DashboardSummaryBloc>().add(LoadDashboardSummary(
          userId: widget.currentUserId,
          date: DateTime.now(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<DashboardSummaryBloc, DashboardSummaryState>(
          builder: (context, state) {
            if (state is DashboardSummaryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardSummaryError) {
              return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
            }

            int taken = 0;
            int left = 0;
            List<DashboardDoseItem> items = [];

            if (state is DashboardSummaryLoaded) {
              taken = state.takenDoses;
              left = state.pendingDoses;
              items = state.doseItems;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Header Segment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'User', // TODO: Load user name dynamically
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'Doses Left',
                          value: left.toString(),
                          icon: Icons.medication,
                          color: AppTheme.primaryGreen,
                          backgroundColor: AppTheme.primaryGreen.withOpacity(0.08),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'Taken Today',
                          value: taken.toString(),
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF2E7D32),
                          backgroundColor: const Color(0xFF2E7D32).withOpacity(0.08),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Today's Schedule Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Schedule",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Schedule List
                  if (items.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            Icon(Icons.check_circle, size: 64, color: AppTheme.primaryGreen.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text('No doses scheduled for today.', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...items.map((item) => _buildScheduleItem(context, item)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, DashboardDoseItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final bool isTaken = item.history.status == DoseStatus.taken;
    final bool isSkipped = item.history.status == DoseStatus.skipped;
    final String timeStr = '${item.history.scheduledTime.hour.toString().padLeft(2, '0')}:${item.history.scheduledTime.minute.toString().padLeft(2, '0')}';
    
    final color = isTaken ? Colors.green : (isSkipped ? Colors.redAccent : colorScheme.primary);

    return GestureDetector(
      onTap: () => _showDoseConfirmationDialog(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medication_liquid, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.medicine.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: isTaken || isSkipped ? TextDecoration.lineThrough : null,
                      color: isTaken || isSkipped ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${item.medicine.dosageAmount} ${item.medicine.dosageUnit ?? ""} • $timeStr',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTaken ? Colors.green.withOpacity(0.1) : (isSkipped ? Colors.red.withOpacity(0.1) : colorScheme.surfaceContainerHighest),
              ),
              child: Icon(
                isTaken ? Icons.check : (isSkipped ? Icons.close : Icons.timer_outlined),
                size: 20,
                color: isTaken ? Colors.green : (isSkipped ? Colors.red : colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
