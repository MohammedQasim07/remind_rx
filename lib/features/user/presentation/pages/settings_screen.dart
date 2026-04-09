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
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppTheme.textDark)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userName = 'Patient Profile';
          String userEmail = 'Sync pending...';
          
          if (state is Authenticated) {
            userName = state.user.name.isNotEmpty ? state.user.name : userName;
            userEmail = state.user.email.isNotEmpty ? state.user.email : userEmail;
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              _buildProfileCard(context, userName, userEmail),
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
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String name, String email) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppTheme.primaryGreen, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
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
            icon: Icons.manage_accounts_outlined,
            title: 'Account Settings',
            subtitle: 'Update personal details',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
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
