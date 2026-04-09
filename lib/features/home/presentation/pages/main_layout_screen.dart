import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/medicine/presentation/pages/medicine_list_screen.dart';
import 'dashboard_screen.dart';
import '../../../dose_history/presentation/pages/daily_tracker_screen.dart';
import '../../../../features/user/presentation/pages/settings_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final String currentUserId;

  const MainLayoutScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(currentUserId: widget.currentUserId),
      DailyTrackerScreen(userId: widget.currentUserId),
      MedicineListScreen(currentUserId: widget.currentUserId),
      SettingsScreen(currentUserId: widget.currentUserId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial for floating nav over content
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.meshBackgroundGradient,
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Home'),
                    _buildNavItem(1, Icons.analytics_outlined, Icons.analytics, 'Analytics'),
                    _buildNavItem(2, Icons.medication_outlined, Icons.medication, 'Meds'),
                    _buildNavItem(3, Icons.settings_outlined, Icons.settings, 'Settings'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppTheme.primaryGreen : AppTheme.textGrey,
            size: 26,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(color: AppTheme.primaryGreen, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
