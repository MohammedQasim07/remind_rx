import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import 'account_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String currentUserId;

  const SettingsScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by parent layout
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userName = 'Patient Profile';
          String userEmail = 'Premium Health Profile';
          String? avatarPath;
          
          if (state is Authenticated) {
            userName = state.user.name.isNotEmpty ? state.user.name : userName;
            userEmail = state.user.email.isNotEmpty ? state.user.email : userEmail;
            avatarPath = state.user.avatarPath;
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              _buildProfileCard(context, userName, userEmail, avatarPath),
              const SizedBox(height: 24),
              _buildSectionTitle('Preferences'),
              const SizedBox(height: 12),
              _buildPreferencesSection(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Account'),
              const SizedBox(height: 12),
              _buildAccountSection(context),
            ],
          );
        },
      )),
    );
  }

  Widget _buildProfileCard(BuildContext context, String name, String email, String? avatarPath) {
    Widget avatarChild = const Icon(Icons.person, color: AppTheme.primaryGreen, size: 40);
    
    if (avatarPath != null) {
      if (avatarPath.startsWith('http')) {
        avatarChild = ClipOval(child: Image.network(avatarPath, fit: BoxFit.cover, width: 80, height: 80));
      } else {
        avatarChild = ClipOval(child: Image.file(File(avatarPath), fit: BoxFit.cover, width: 80, height: 80));
      }
    }

    return GestureDetector(
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
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text('App Preferences', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textGrey)),
            Text('Account Settings', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5)),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.primaryGreen, Color(0xFF008960)]),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: avatarChild,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(email, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                ]
              )
            )
          ]
        ),
      )
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.textDark,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications',
            subtitle: 'Alarms and reminders',
            trailing: Switch(
              value: true,
              onChanged: (val) {
                // Future: Toggle global notifications
              },
              activeColor: AppTheme.primaryGreen,
            ),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English (US)',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Language is locked to English'), backgroundColor: AppTheme.textGrey),
               );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'Made By BitXero',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
            onTap: () {
              showDialog(
                context: context, 
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  contentPadding: const EdgeInsets.all(24),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.health_and_safety_rounded, color: AppTheme.primaryGreen, size: 48),
                        ),
                        const SizedBox(height: 16),
                        const Text('RemindRx Premium', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                        const SizedBox(height: 4),
                        const Text('v1.0.0 (Build 42)', style: TextStyle(color: AppTheme.textGrey)),
                        const SizedBox(height: 24),
                        const Text(
                          'RemindRx is your ultimate intelligent health companion. Expertly crafted to simplify medication tracking, manage smart inventory, and ensure you never miss a dose.', 
                          style: TextStyle(fontSize: 14, height: 1.5, color: AppTheme.textGrey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Development Team', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              SizedBox(height: 4),
                              Text('Mohammed Qasim\nAli Khalil\nAbdulqader Taha', style: TextStyle(color: AppTheme.textGrey, fontSize: 13, height: 1.4)),
                              SizedBox(height: 16),
                              Text('Contact Us', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              SizedBox(height: 4),
                              Text('info@bitxero-iq.com', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                              SizedBox(height: 16),
                              Text('Website', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              SizedBox(height: 4),
                              Text('https://bitxero-iq.com', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                            ]
                          )
                        ),
                        const SizedBox(height: 24),
                        const Text('© 2026 BitXero. All Rights Reserved.', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                      ]
                    )
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                    )
                  ]
                )
              );
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            iconColor: Colors.redAccent,
            titleColor: Colors.redAccent,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color iconColor = AppTheme.primaryGreen,
    Color titleColor = AppTheme.textDark,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 60, endIndent: 20, color: AppTheme.textGrey.withOpacity(0.2));
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out of your account?', style: TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(100, 40),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
