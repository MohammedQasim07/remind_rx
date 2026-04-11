import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/avatar_selector.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../domain/entities/user.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import 'package:remind_rx/l10n/app_localizations.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  late User _currentUser;
  String? _avatarPath;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with safe fallbacks
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    // Populate data from BLoC state
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _currentUser = state.user;
      _nameController.text = _currentUser.name;
      _emailController.text = _currentUser.email;
      _phoneController.text = _currentUser.phone;
      _avatarPath = _currentUser.avatarPath;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (_currentUser.email.isEmpty) {
        _emailController.text = AppLocalizations.of(context)!.noEmailProvided;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Create new user instance with updated values
      final updatedUser = User(
        id: _currentUser.id,
        name: _nameController.text.trim(),
        email: _currentUser.email, // Email should be modified through a separate flow ideally
        phone: _phoneController.text.trim(),
        phoneCountryCode: _currentUser.phoneCountryCode,
        role: _currentUser.role,
        gender: _currentUser.gender,
        avatarPath: _avatarPath,
      );

      // Dispatch event to update User Profile
      context.read<AuthBloc>().add(UpdateUserProfile(updatedUser));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.accountSaved),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.deleteAccount, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: Text(
            AppLocalizations.of(context)!.deleteAccountConfirm,
            style: const TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    // Ideally call API to delete account. For Offline-First mock, just log out.
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSettings, style: const TextStyle(color: AppTheme.textDark)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.meshBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  AvatarSelector(
                    currentAvatarPath: _avatarPath,
                    onAvatarSelected: (path) => setState(() => _avatarPath = path),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(AppLocalizations.of(context)!.personalInfo),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: AppLocalizations.of(context)!.name,
                          icon: Icons.person_outline,
                          validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.nameCannotBeEmpty : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: AppLocalizations.of(context)!.phone,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(AppLocalizations.of(context)!.preferences),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _emailController,
                          label: AppLocalizations.of(context)!.emailReadOnly,
                          icon: Icons.email_outlined,
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(AppLocalizations.of(context)!.changePassword, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600)),
                          trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.passwordNotImplemented)));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(AppLocalizations.of(context)!.saveChanges, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(AppLocalizations.of(context)!.dangerZone),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      title: Text(AppLocalizations.of(context)!.deleteAccount, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      subtitle: Text(AppLocalizations.of(context)!.deleteAccountDesc, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                      trailing: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                      onTap: _confirmDeleteAccount,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.textGrey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: enabled ? AppTheme.textDark : AppTheme.textGrey),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textGrey),
        prefixIcon: Icon(icon, color: enabled ? AppTheme.primaryGreen : AppTheme.textGrey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
      ),
    );
  }
}
