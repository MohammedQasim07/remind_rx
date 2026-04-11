import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'register_screen.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';

import 'package:remind_rx/l10n/app_localizations.dart';
import '../../../../core/bloc/language/language_bloc.dart';
import '../../../../core/bloc/language/language_event.dart';
import '../../../../core/bloc/language/language_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            ),
          );
    }
  }

  InputDecoration _buildInputDecoration({required String label, required IconData icon, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppTheme.textGrey),
      prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.white.withOpacity(0.85),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        final isArabic = state.locale.languageCode == 'ar';
        return GestureDetector(
          onTap: () {
            final newLocale = isArabic ? const Locale('en') : const Locale('ar');
            context.read<LanguageBloc>().add(ChangeLanguage(newLocale));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.translate_rounded, size: 16, color: AppTheme.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'English' : 'العربية',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.meshBackgroundGradient),
          child: SafeArea(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: _buildLanguageToggle(),
                          ),
                          const Spacer(flex: 1),
                          // Premium Branding
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.15), blurRadius: 30, spreadRadius: 5)],
                              ),
                              child: const Icon(Icons.health_and_safety_rounded, size: 72, color: AppTheme.primaryGreen),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.appTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen, letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.appSlogan,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: AppTheme.textGrey, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(flex: 2),

                          // Glass Form
                          GlassCard(
                            padding: const EdgeInsets.all(32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l10n.welcomeBack,
                                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(l10n.pleaseLogin, style: const TextStyle(color: AppTheme.textGrey, fontSize: 15)),
                                  const SizedBox(height: 32),
                                  
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: _buildInputDecoration(label: l10n.email, icon: Icons.email_outlined),
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) return l10n.enterEmail;
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) return l10n.enterValidEmail;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600),
                                    decoration: _buildInputDecoration(
                                      label: l10n.password,
                                      icon: Icons.lock_outline_rounded,
                                      suffixIcon: IconButton(
                                        icon: Icon(_isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: AppTheme.textGrey),
                                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                      ),
                                    ),
                                    validator: (value) => value == null || value.length < 6 ? l10n.passwordLength : null,
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: TextButton(
                                      onPressed: () {}, 
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                      child: Text(l10n.forgotPassword, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w800)),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        onPressed: state is AuthLoading ? null : _onLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.primaryGreen,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          elevation: 8,
                                          shadowColor: AppTheme.primaryGreen.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        child: state is AuthLoading
                                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                            : Text(l10n.logIn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(l10n.noAccount, style: const TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
                                },
                                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                child: Text(l10n.signUp, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w900, fontSize: 16, decoration: TextDecoration.underline, decorationColor: AppTheme.primaryGreen)),
                              ),
                            ],
                          ),
                          const Spacer(flex: 1),
                        ],
                      ),
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
}

