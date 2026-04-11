import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/user/presentation/pages/account_settings_screen.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/dashboard_summary_bloc.dart';
import '../bloc/dashboard_summary_event.dart';
import '../bloc/dashboard_summary_state.dart';
import '../../../../features/dose_history/domain/entities/dose_history.dart';
import '../../../../features/user/presentation/bloc/auth_bloc.dart';
import '../../../../features/user/presentation/bloc/auth_state.dart';
import '../../../../features/medicine/presentation/pages/add_medicine_screen.dart';
import '../../../../features/medicine/presentation/pages/medicine_list_screen.dart';
import '../../../../features/dose_history/presentation/pages/daily_tracker_screen.dart';
import '../../../../features/dose_history/presentation/bloc/dose_history_bloc.dart';
import '../../../../features/dose_history/presentation/bloc/dose_history_event.dart';
import '../../../../features/medicine/presentation/bloc/medicine_bloc.dart';
import '../../../../features/medicine/presentation/bloc/medicine_event.dart';
import 'package:remind_rx/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  final String currentUserId;

  const DashboardScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<DashboardSummaryBloc>().add(LoadDashboardSummary(
          userId: widget.currentUserId,
          date: _selectedDate,
        ));
  }




  DashboardDoseItem? _getUpcomingDose(List<DashboardDoseItem> items) {
    // Determine the next dose only if viewing "today"
    final now = DateTime.now();
    if (_selectedDate.year == now.year && _selectedDate.month == now.month && _selectedDate.day == now.day) {
      try {
        return items.firstWhere((item) => item.history.status == DoseStatus.scheduled);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent, // Respects global mesh gradient
      body: SafeArea(
        child: BlocBuilder<DashboardSummaryBloc, DashboardSummaryState>(
          builder: (context, state) {
            int taken = 0;
            int pending = 0;
            List<DashboardDoseItem> items = [];

            if (state is DashboardSummaryLoaded) {
              taken = state.takenDoses;
              pending = state.pendingDoses;
              items = state.doseItems;
            }

            final totalDoses = taken + pending;
            final double progress = totalDoses > 0 ? (taken / totalDoses) : 0.0;
            final upcomingDose = _getUpcomingDose(items);

            // Dynamically generate 14 days centered around the selected date
            final List<DateTime> weekDates = List.generate(14, (index) => _selectedDate.subtract(const Duration(days: 3)).add(Duration(days: index)));

            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Dynamic Greeting Header
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      String? avatarPath;
                      if (authState is Authenticated) {
                        avatarPath = authState.user.avatarPath;
                      }
                      
                      Widget avatarChild = const Icon(Icons.person, color: AppTheme.primaryGreen, size: 28);
                      if (avatarPath != null) {
                        if (avatarPath!.startsWith('http')) {
                          avatarChild = ClipOval(child: Image.network(avatarPath, fit: BoxFit.cover, width: 56, height: 56));
                        } else {
                          avatarChild = ClipOval(child: Image.file(File(avatarPath), fit: BoxFit.cover, width: 56, height: 56));
                        }
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.welcomeBack, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textGrey)),
                                Text(
                                  l10n.home,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.85,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                                    ),
                                    child: const AccountSettingsScreen(),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 56, height: 56,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.9), width: 3),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                              ),
                              child: avatarChild,
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                  const SizedBox(height: 24),

                  // 2. Horizontal Date Strip with Calendar Picker
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: AppTheme.primaryGreen,
                                      onPrimary: Colors.white,
                                      onSurface: AppTheme.textDark,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                              _loadData();
                            }
                          },
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryGreen, size: 28),
                                const SizedBox(height: 4),
                                Text(l10n.pickTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textGrey)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: weekDates.length,
                            itemBuilder: (ctx, index) {
                              final date = weekDates[index];
                        final isSelected = date.year == _selectedDate.year &&
                            date.month == _selectedDate.month &&
                            date.day == _selectedDate.day;
                        final isToday = date.year == DateTime.now().year &&
                            date.month == DateTime.now().month &&
                            date.day == DateTime.now().day;

                        final dayName = _getDayName(context, date.weekday);
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedDate = date);
                            _loadData();
                          },
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryGreen : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppTheme.primaryGreen : Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : AppTheme.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : AppTheme.textDark,
                                  ),
                                ),
                                if (isToday && !isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(color: AppTheme.primaryGreen, shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

                  // 3. Quick Actions Hub
                  _buildQuickActionsHub(),
                  const SizedBox(height: 24),

                  // 4. Low Stock Banner
                  if (items.isNotEmpty) _buildLowStockBanner(items),

                  // 5. Adherence Ring (Hero Card)
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.tracker, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5)),
                              const SizedBox(height: 8),
                              Text(
                                totalDoses == 0 
                                  ? l10n.noDoses 
                                  : '${l10n.dailyAdherence}: ${(progress * 100).toInt()}%',
                                style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: totalDoses == 0 ? 0.0 : progress,
                                strokeWidth: 8,
                                backgroundColor: AppTheme.primaryGreen.withOpacity(0.15),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                                strokeCap: StrokeCap.round,
                              ),
                              Center(
                                child: Text(
                                  totalDoses == 0 ? '-' : '${taken}/${totalDoses}',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  Text(l10n.tracker, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5)),
                  const SizedBox(height: 16),

                  // 6. Glass Schedule List
                  if (state is DashboardSummaryLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (items.isEmpty)
                    GlassCard(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 60, color: AppTheme.primaryGreen.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(l10n.noDoses, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textGrey)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...items.map((item) => _buildGlassScheduleItem(context, item, isUpcoming: item == upcomingDose)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickActionsHub() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionItem(
          icon: Icons.medication_rounded,
          label: l10n.addMedicine,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddMedicineScreen(currentUserId: widget.currentUserId)))
              .then((_) => _loadData());
          },
        ),
        _buildActionItem(
          icon: Icons.list_alt_rounded,
          label: l10n.meds,
          color: AppTheme.primaryGreen,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => MedicineListScreen(currentUserId: widget.currentUserId)))
              .then((_) => _loadData());
          },
        ),
        _buildActionItem(
          icon: Icons.analytics_rounded,
          label: l10n.analytics,
          color: Colors.purpleAccent,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => DailyTrackerScreen(userId: widget.currentUserId)))
              .then((_) => _loadData());
          },
        ),
      ],
    );
  }

  Widget _buildActionItem({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  Widget _buildLowStockBanner(List<DashboardDoseItem> items) {
    final l10n = AppLocalizations.of(context)!;
    // Find medicines that are low on stock
    final lowStockMedicines = items
        .map((item) => item.medicine)
        .where((med) => med.stockQuantity <= med.lowStockThreshold)
        .toSet(); // using Set to avoid duplicates if scheduled multiple times a day

    if (lowStockMedicines.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.withOpacity(0.4), width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(l10n.lowStockAlert, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    '${lowStockMedicines.map((m) => m.name).join(', ')}',
                    style: const TextStyle(fontSize: 13, color: Colors.deepOrange),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(BuildContext context, int weekday) {
    final languageCode = AppLocalizations.of(context)!.localeName;
    if (languageCode == 'ar') {
      switch (weekday) {
        case 1: return 'الاثنين';
        case 2: return 'الثلاثاء';
        case 3: return 'الأربعاء';
        case 4: return 'الخميس';
        case 5: return 'الجمعة';
        case 6: return 'السبت';
        case 7: return 'الأحد';
        default: return '';
      }
    } else {
      switch (weekday) {
        case 1: return 'Mon';
        case 2: return 'Tue';
        case 3: return 'Wed';
        case 4: return 'Thu';
        case 5: return 'Fri';
        case 6: return 'Sat';
        case 7: return 'Sun';
        default: return '';
      }
    }
  }

  Widget _buildGlassScheduleItem(BuildContext context, DashboardDoseItem item, {bool isUpcoming = false}) {
    final l10n = AppLocalizations.of(context)!;
    final bool isTaken = item.history.status == DoseStatus.taken;
    final bool isSkipped = item.history.status == DoseStatus.skipped;
    final String timeStr = '${item.history.scheduledTime.hour.toString().padLeft(2, '0')}:${item.history.scheduledTime.minute.toString().padLeft(2, '0')}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: isUpcoming
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.3), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 4)),
              ],
            )
          : null,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        onTap: isTaken || isSkipped ? null : () => _showDoseConfirmationDialog(item),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUpcoming) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Text('${l10n.home} ⏳', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: -0.2)),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isTaken || isSkipped ? Colors.grey.withOpacity(0.1) : AppTheme.primaryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isSkipped ? Icons.block_rounded : Icons.vaccines_rounded, 
                  color: isTaken || isSkipped ? Colors.grey : AppTheme.primaryGreen
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.medicine.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        decoration: isTaken || isSkipped ? TextDecoration.lineThrough : null,
                        color: isTaken || isSkipped ? AppTheme.textGrey : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.monitor_weight_outlined, size: 14, color: AppTheme.textGrey.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        Text('${item.medicine.dosageAmount} ${item.medicine.dosageUnit ?? ""}'.trim(), style: TextStyle(fontSize: 13, color: AppTheme.textGrey, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textGrey.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        Text(timeStr, style: TextStyle(fontSize: 13, color: AppTheme.textGrey, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              if (isTaken)
                const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen, size: 28)
              else if (isSkipped)
                const Icon(Icons.cancel_rounded, color: Colors.orange, size: 28)
              else
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isUpcoming ? AppTheme.primaryGreen.withOpacity(0.2) : Colors.white.withOpacity(0.8)),
                  child: Icon(Icons.hourglass_empty_rounded, size: 18, color: isUpcoming ? AppTheme.primaryGreen : AppTheme.textGrey),
                ),
            ],
          ),
        ],
      ),
    ));
  }

  void _showDoseConfirmationDialog(DashboardDoseItem item) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 24),
              Icon(Icons.vaccines_rounded, color: AppTheme.primaryGreen.withOpacity(0.5), size: 48),
              const SizedBox(height: 16),
              Text(l10n.didYouTakeDose(item.medicine.name), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('${l10n.dosage}: ${item.medicine.dosageAmount} ${item.medicine.dosageUnit ?? ""}', style: const TextStyle(fontSize: 16, color: AppTheme.textGrey)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18), 
                        side: BorderSide(color: Colors.orange.withOpacity(0.5), width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.block_rounded, color: Colors.orange),
                      label: Text(l10n.skip, style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        context.read<DashboardSummaryBloc>().add(MarkDoseStatus(
                          historyId: item.history.id, 
                          status: DoseStatus.skipped, 
                          actualTime: DateTime.now()
                        ));
                        context.read<DoseHistoryBloc>().add(UpdateDoseStatus(
                          historyId: item.history.id, 
                          status: DoseStatus.skipped, 
                          actualTime: DateTime.now()
                        ));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(child: Text(l10n.doseSkippedSuccess, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                            ],
                          ),
                          backgroundColor: Colors.orange.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          margin: const EdgeInsets.all(16),
                        ));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen, 
                        padding: const EdgeInsets.symmetric(vertical: 18), 
                        elevation: 8,
                        shadowColor: AppTheme.primaryGreen.withOpacity(0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                      label: Text(l10n.take, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        // 1. Mark as taken
                        context.read<DashboardSummaryBloc>().add(MarkDoseStatus(
                          historyId: item.history.id, 
                          status: DoseStatus.taken, 
                          actualTime: DateTime.now()
                        ));
                        context.read<DoseHistoryBloc>().add(UpdateDoseStatus(
                          historyId: item.history.id, 
                          status: DoseStatus.taken, 
                          actualTime: DateTime.now()
                        ));
                        
                        // 2. Deduct Inventory!
                        final med = item.medicine;
                        final newStock = (med.stockQuantity - med.dosageAmount).toInt();
                        if (newStock >= 0) {
                           context.read<MedicineBloc>().add(UpdateMedicine(med.copyWith(stockQuantity: newStock)));
                        } else {
                           context.read<MedicineBloc>().add(UpdateMedicine(med.copyWith(stockQuantity: 0)));
                        }
                        
                        Navigator.pop(ctx);
                        
                        // Show beautiful success
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(child: Text(l10n.doseTakenSuccess, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                            ],
                          ),
                          backgroundColor: AppTheme.primaryGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          margin: const EdgeInsets.all(16),
                        ));
                      },
                    ),
                  ),
                ]
              )
            ]
          )
        );
      }
    );
  }
}
