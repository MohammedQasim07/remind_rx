import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import 'account_settings_screen.dart';
import 'package:remind_rx/core/bloc/language/language_event.dart';
import 'package:remind_rx/core/bloc/notifications/notifications_bloc.dart';
import 'package:remind_rx/core/bloc/notifications/notifications_event.dart';
import 'package:remind_rx/core/bloc/notifications/notifications_state.dart';
import 'package:remind_rx/features/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:remind_rx/features/medicine/presentation/bloc/medicine_event.dart';
import 'package:remind_rx/l10n/app_localizations.dart';
import 'package:remind_rx/core/bloc/language/language_bloc.dart';

class SettingsScreen extends StatelessWidget {
  final String currentUserId;

  const SettingsScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by parent layout
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userName = l10n.name;
          String userEmail = l10n.appTitle;
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
              _buildSectionTitle(l10n.preferences),
              const SizedBox(height: 12),
              _buildPreferencesSection(context),
              const SizedBox(height: 24),
              _buildSectionTitle(l10n.account),
              const SizedBox(height: 12),
              _buildAccountSection(context),
            ],
          );
        },
      )),
    );
  }

  Widget _buildProfileCard(BuildContext context, String name, String email, String? avatarPath) {
    final l10n = AppLocalizations.of(context)!;
    Widget avatarChild = const Icon(Icons.person, color: AppTheme.primaryGreen, size: 40);
    
    // ... same avatar logic ...
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
            Text(l10n.appPreferences, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textGrey)),
            Text(l10n.accountSettings, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5)),
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
      padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
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
    final l10n = AppLocalizations.of(context)!;
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              return _buildSettingsTile(
                icon: Icons.notifications_active_outlined,
                title: l10n.notifications,
                subtitle: l10n.alarmsReminders,
                trailing: Switch(
                  value: state.isEnabled,
                  onChanged: (val) {
                    context.read<NotificationsBloc>().add(ToggleNotifications(val));
                    if (val) {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is Authenticated) {
                        context.read<MedicineBloc>().add(RescheduleAllAlarms(authState.user.id));
                      }
                    }
                  },
                  activeColor: AppTheme.primaryGreen,
                ),
              );
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: l10n.language,
            subtitle: Localizations.localeOf(context).languageCode == 'ar' ? 'العربية' : 'English',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
            onTap: () => _showLanguagePicker(context),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.selectLanguage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.english),
              leading: const Icon(Icons.language, color: AppTheme.primaryGreen),
              onTap: () {
                context.read<LanguageBloc>().add(const ChangeLanguage(Locale('en')));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(l10n.arabic),
              leading: const Icon(Icons.language, color: AppTheme.primaryGreen),
              onTap: () {
                context.read<LanguageBloc>().add(const ChangeLanguage(Locale('ar')));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.info_outline_rounded,
            title: l10n.about,
            subtitle: l10n.madeBy,
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
                        Text(l10n.remindRxPremium, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                        const SizedBox(height: 4),
                        Text(l10n.appVersion, style: const TextStyle(color: AppTheme.textGrey)),
                        const SizedBox(height: 24),
                        Text(
                          l10n.appDescription, 
                          style: const TextStyle(fontSize: 14, height: 1.5, color: AppTheme.textGrey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.developmentTeam, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              const SizedBox(height: 4),
                              Text(l10n.devTeamNames, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13, height: 1.4)),
                              const SizedBox(height: 16),
                              Text(l10n.contactUs, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              const SizedBox(height: 4),
                              const Text('info@bitxero-iq.com', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                              const SizedBox(height: 16),
                              Text(l10n.website, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              const SizedBox(height: 4),
                              const Text('https://bitxero-iq.com', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                            ]
                          )
                        ),
                        const SizedBox(height: 24),
                        Text(l10n.allRightsReserved, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                      ]
                    )
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(l10n.close, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                    )
                  ]
                )
              );
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.logout_rounded,
            title: l10n.logOut,
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.logOut, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        content: Text(l10n.logoutConfirm, style: const TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
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
            child: Text(l10n.logOut),
          ),
        ],
      ),
    );
  }
}
