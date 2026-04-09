import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/avatar_selector.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form Keys
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+964');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String? _avatarPath;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    FocusScope.of(context).unfocus();
    if (_currentStep == 0) {
      if (_step1FormKey.currentState!.validate()) {
        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    } else if (_currentStep == 1) {
      if (_step2FormKey.currentState!.validate()) {
         _submitRegistration();
      }
    }
  }

  void _previousStep() {
    FocusScope.of(context).unfocus();
    _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void _submitRegistration() {
    context.read<AuthBloc>().add(
      RegisterRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        phoneCountryCode: _countryCodeController.text.trim(),
        avatarPath: _avatarPath,
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String label, required IconData icon, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppTheme.textGrey),
      prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.shade50,
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

  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const Text('Who are you?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 8),
            const Text('Upload a photo or pick an avatar for your medical profile.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textGrey)),
            const SizedBox(height: 32),
            
            AvatarSelector(
              currentAvatarPath: _avatarPath, 
              size: 130,
              onAvatarSelected: (val) => setState(() => _avatarPath = val)
            ),
            const SizedBox(height: 32),

            TextFormField(
              controller: _nameController,
              decoration: _buildInputDecoration(label: 'Full Name', icon: Icons.person_outline),
              validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your real name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: _buildInputDecoration(label: 'Email Address', icon: Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) return 'Enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _countryCodeController,
                    decoration: _buildInputDecoration(label: 'Code', icon: Icons.public).copyWith(prefixIcon: null),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.trim().isEmpty ? 'Req' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: _buildInputDecoration(label: 'Phone Number', icon: Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your phone number' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    bool passwordMatches = _passwordController.text.isNotEmpty && _passwordController.text == _confirmPasswordController.text;
    bool passwordLongEnough = _passwordController.text.length >= 6;

    return Form(
      key: _step2FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const Text('Secure your account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 8),
            const Text('Protect your health data with a strong password.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textGrey)),
            const SizedBox(height: 48),

            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              onChanged: (val) => setState((){}),
              decoration: _buildInputDecoration(
                label: 'Password', 
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              validator: (value) => value == null || value.length < 6 ? 'Must be at least 6 characters' : null,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                   Icon(passwordLongEnough ? Icons.check_circle : Icons.radio_button_unchecked, color: passwordLongEnough ? AppTheme.primaryGreen : Colors.grey, size: 16),
                   const SizedBox(width: 8),
                   Text('At least 6 characters', style: TextStyle(color: passwordLongEnough ? AppTheme.primaryGreen : Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              onChanged: (val) => setState((){}),
              decoration: _buildInputDecoration(
                label: 'Confirm Password', 
                icon: Icons.lock_reset,
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                  onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm your password';
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                   Icon(passwordMatches ? Icons.check_circle : Icons.radio_button_unchecked, color: passwordMatches ? AppTheme.primaryGreen : Colors.grey, size: 16),
                   const SizedBox(width: 8),
                   Text('Passwords match', style: TextStyle(color: passwordMatches ? AppTheme.primaryGreen : Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
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
        child: Column(
          children: [
            // Custom App Bar Header Area
            Container(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 20),
              decoration: const BoxDecoration(
                gradient: AppTheme.meshBackgroundGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textDark),
                        onPressed: () {
                           if (_currentStep == 1) {
                             _previousStep();
                           } else {
                             Navigator.of(context).pop();
                           }
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: _currentStep >= 0 ? AppTheme.primaryGreen : Colors.grey.shade300, shape: BoxShape.circle),
                          ),
                          Container(width: 30, height: 3, color: _currentStep >= 1 ? AppTheme.primaryGreen : Colors.grey.shade300),
                          Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: _currentStep >= 1 ? AppTheme.primaryGreen : Colors.grey.shade300, shape: BoxShape.circle),
                          ),
                        ]
                      ),
                      const SizedBox(width: 48), // Balance for arrow back
                    ],
                  ),
                ],
              )
            ),
            
            // Sliding Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe to force validation
                onPageChanged: (idx) => setState(() => _currentStep = idx),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                ],
              ),
            ),

            // Bottom Navigation Area
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]
              ),
              child: Row(
                children: [
                  if (_currentStep == 1)
                     Expanded(
                       flex: 1,
                       child: OutlinedButton(
                         onPressed: _previousStep,
                         style: OutlinedButton.styleFrom(
                           padding: const EdgeInsets.symmetric(vertical: 16),
                           side: const BorderSide(color: AppTheme.primaryGreen),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                         ),
                         child: const Text('Back', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                       ),
                     ),
                  if (_currentStep == 1) const SizedBox(width: 16),
                  
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(_currentStep == 0 ? 'Continue' : 'Create Account', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
