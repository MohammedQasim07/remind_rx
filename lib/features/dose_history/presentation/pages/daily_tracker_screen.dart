import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dose_history.dart';
import '../bloc/dose_history_bloc.dart';
import '../bloc/dose_history_event.dart';
import '../bloc/dose_history_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import 'package:remind_rx/l10n/app_localizations.dart';

class DailyTrackerScreen extends StatefulWidget {
  final String userId;

  const DailyTrackerScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<DailyTrackerScreen> createState() => _DailyTrackerScreenState();
}

class _DailyTrackerScreenState extends State<DailyTrackerScreen> {
  int? _selectedDaysAgo; // null means week overview

  @override
  void initState() {
    super.initState();
    context.read<DoseHistoryBloc>().add(LoadWeeklyDoseHistory(widget.userId));
  }

  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration:
          const BoxDecoration(gradient: AppTheme.meshBackgroundGradient),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(child: BlocBuilder<DoseHistoryBloc, DoseHistoryState>(
            builder: (context, state) {
              if (state is DoseHistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DoseHistoryLoaded) {
                return _buildAnalyticsContent(context, state.dailyHistory);
              } else if (state is DoseHistoryError) {
                return Center(
                    child: Text(state.message,
                        style: const TextStyle(color: Colors.redAccent)));
              }
              return const SizedBox.shrink();
            },
          ))),
    );
  }

  Widget _buildAnalyticsContent(
      BuildContext context, List<DoseHistory> history) {
    final l10n = AppLocalizations.of(context)!;
    // 1. Process data for last 7 days chart (Always 7 days)
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    Map<int, Map<String, int>> dailyStats = {};
    for (int i = 6; i >= 0; i--) {
      dailyStats[i] = {'taken': 0, 'total': 0};
    }

    for (var dose in history) {
      final doseDay = DateTime(dose.scheduledTime.year,
          dose.scheduledTime.month, dose.scheduledTime.day);
      final differenceInDays = todayStart.difference(doseDay).inDays;

      if (differenceInDays >= 0 && differenceInDays <= 6) {
        dailyStats[differenceInDays]!['total'] =
            dailyStats[differenceInDays]!['total']! + 1;
        if (dose.status == DoseStatus.taken) {
          dailyStats[differenceInDays]!['taken'] =
              dailyStats[differenceInDays]!['taken']! + 1;
        }
      }
    }

    // 2. Filter data for the Stats & Insights cards based on selection
    List<DoseHistory> displayHistory = history;
    String overviewTitle = l10n.weeklyOverview;

    if (_selectedDaysAgo != null) {
      final selectedDate =
          todayStart.subtract(Duration(days: _selectedDaysAgo!));
      displayHistory = history
          .where((h) =>
              h.scheduledTime.year == selectedDate.year &&
              h.scheduledTime.month == selectedDate.month &&
              h.scheduledTime.day == selectedDate.day)
          .toList();

      if (_selectedDaysAgo == 0) {
        overviewTitle = l10n.todayOverview;
      } else if (_selectedDaysAgo == 1) {
        overviewTitle = l10n.yesterdayOverview;
      } else {
        overviewTitle = l10n.dayOverview(
            DateFormat('EEEE', AppLocalizations.of(context)!.localeName)
                .format(selectedDate));
      }
    }

    int totalScheduled = displayHistory.length;
    int totalTaken =
        displayHistory.where((h) => h.status == DoseStatus.taken).length;
    int totalSkippedOrMissed = displayHistory
        .where((h) =>
            h.status == DoseStatus.skipped || h.status == DoseStatus.missed)
        .length;
    double adherence = totalScheduled > 0 ? (totalTaken / totalScheduled) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
          .copyWith(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // DATA HEADER INJECTION
          const SizedBox(height: 10),
          Center(
            child: Column(children: [
              Text(l10n.performance,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppTheme.textGrey)),
              Text(l10n.healthCompliance,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      letterSpacing: -0.5)),
              const SizedBox(height: 32),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: adherence,
                      strokeWidth: 12,
                      backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                      color: _getAdherenceColor(adherence),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(adherence * 100).toInt()}%',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: _getAdherenceColor(adherence))),
                      Text(l10n.compliance,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textGrey)),
                    ],
                  )
                ],
              ),
            ]),
          ),
          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.weeklyAdherence,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      letterSpacing: -0.5)),
              if (_selectedDaysAgo != null)
                GestureDetector(
                  onTap: () => setState(() => _selectedDaysAgo = null),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppTheme.textGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(l10n.reset,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textGrey)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCustomBarChart(dailyStats, todayStart),

          const SizedBox(height: 36),
          Text(overviewTitle,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.5)),
          const SizedBox(height: 16),
          _buildStatsRow(totalScheduled, totalTaken, totalSkippedOrMissed),

          const SizedBox(height: 36),
          Text(l10n.insights,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.5)),
          const SizedBox(height: 16),
          _buildInsightCard(
              adherence, totalScheduled, _selectedDaysAgo != null),
        ],
      ),
    );
  }

  Color _getAdherenceColor(double rate) {
    if (rate >= 0.8) return AppTheme.primaryGreen;
    if (rate >= 0.5) return Colors.orange;
    return Colors.redAccent;
  }

  Widget _buildStatsRow(int total, int taken, int missed) {
    final l10n = AppLocalizations.of(context)!;
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(l10n.takenToday, taken.toString(),
              AppTheme.primaryGreen, Icons.check_circle_rounded),
          Container(
              height: 40, width: 1, color: AppTheme.textGrey.withOpacity(0.2)),
          _buildStatItem(l10n.missed, missed.toString(), Colors.orange,
              Icons.warning_rounded),
          Container(
              height: 40, width: 1, color: AppTheme.textGrey.withOpacity(0.2)),
          _buildStatItem(l10n.total, total.toString(), Colors.blueAccent,
              Icons.medication_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 12),
        Text(value,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _getLocalizedDayInitials(BuildContext context, DateTime date) {
    final languageCode = AppLocalizations.of(context)!.localeName;
    if (languageCode == 'ar') {
      switch (date.weekday) {
        case 1:
          return 'إ'; // الاثنين
        case 2:
          return 'ث'; // الثلاثاء
        case 3:
          return 'أ'; // الأربعاء
        case 4:
          return 'خ'; // الخميس
        case 5:
          return 'ج'; // الجمعة
        case 6:
          return 'س'; // السبت
        case 7:
          return 'ح'; // الأحد
        default:
          return '';
      }
    } else {
      return DateFormat('EE', 'en').format(date).substring(0, 1);
    }
  }

  Widget _buildCustomBarChart(
      Map<int, Map<String, int>> dailyStats, DateTime today) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                int daysAgo = 6 - index;
                final stats = dailyStats[daysAgo]!;
                final total = stats['total']!;
                final taken = stats['taken']!;

                double percentage = total > 0 ? (taken / total) : 0.0;
                if (total == 0) percentage = 0.05;

                final date = today.subtract(Duration(days: daysAgo));
                final dayLabel = _getLocalizedDayInitials(context, date);

                final bool isSelected = _selectedDaysAgo == daysAgo;
                final bool hasSelection = _selectedDaysAgo != null;

                // Color logic: if a day is selected, others are faded.
                final gradientColors = (hasSelection && !isSelected)
                    ? [
                        Colors.grey.withOpacity(0.2),
                        Colors.grey.withOpacity(0.4)
                      ]
                    : [
                        AppTheme.primaryGreen.withOpacity(0.5),
                        AppTheme.primaryGreen
                      ];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedDaysAgo == daysAgo) {
                        _selectedDaysAgo = null;
                      } else {
                        _selectedDaysAgo = daysAgo;
                      }
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 140 * percentage,
                        width: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: AppTheme.primaryGreen
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4))
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dayLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: (daysAgo == 0 || isSelected)
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : ((hasSelection)
                                  ? AppTheme.textGrey.withOpacity(0.5)
                                  : AppTheme.textDark),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(double adherence, int totalDoses, bool isSingleDay) {
    final l10n = AppLocalizations.of(context)!;
    String title = l10n.gettingStarted;
    String subtitle = isSingleDay ? l10n.noDoses : l10n.createAccount;
    IconData icon = Icons.lightbulb_outline;
    Color color = Colors.blueAccent;

    if (totalDoses > 0) {
      if (adherence >= 0.9) {
        title = isSingleDay ? l10n.perfectDay : l10n.incredibleJob;
        subtitle = isSingleDay ? l10n.perfectDay : l10n.incredibleJob;
        icon = Icons.emoji_events_rounded;
        color = Colors.amber;
      } else if (adherence >= 0.6) {
        title = isSingleDay ? l10n.almostPerfect : l10n.doingGood;
        subtitle = isSingleDay ? l10n.almostPerfect : l10n.doingGood;
        icon = Icons.thumb_up_alt_rounded;
        color = AppTheme.primaryGreen;
      } else {
        title = isSingleDay ? l10n.toughDay : l10n.needsAttention;
        subtitle = isSingleDay ? l10n.toughDay : l10n.needsAttention;
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 14, color: AppTheme.textGrey, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
