import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/medicine.dart';
import '../bloc/medicine_bloc.dart';
import '../bloc/medicine_event.dart';
import '../bloc/medicine_state.dart';

// ─── Medicine Type Visual Config ──────────────────────────────────
class _MedicineTypeOption {
  final MedicineType type;
  final String emoji;
  final String label;
  final String hint;
  const _MedicineTypeOption({required this.type, required this.emoji, required this.label, required this.hint});
}

const _typeOptions = [
  _MedicineTypeOption(type: MedicineType.pill,     emoji: '💊', label: 'Pill',     hint: 'Tablet or pill'),
  _MedicineTypeOption(type: MedicineType.capsule,  emoji: '💉', label: 'Capsule',  hint: 'Capsule form'),
  _MedicineTypeOption(type: MedicineType.liquid,   emoji: '🧴', label: 'Syrup',    hint: 'Liquid / Syrup'),
  _MedicineTypeOption(type: MedicineType.injection,emoji: '💉', label: 'Injection',hint: 'Injectable'),
  _MedicineTypeOption(type: MedicineType.inhaler,  emoji: '🫁', label: 'Inhaler',  hint: 'Breathing aid'),
  _MedicineTypeOption(type: MedicineType.drops,    emoji: '💧', label: 'Drops',    hint: 'Eye / Ear drops'),
  _MedicineTypeOption(type: MedicineType.cream,    emoji: '🧼', label: 'Cream',    hint: 'Topical cream'),
  _MedicineTypeOption(type: MedicineType.other,    emoji: '📦', label: 'Other',    hint: 'Something else'),
];

// ─── Common dosage units per type ─────────────────────────────────
const _unitSuggestions = ['mg', 'ml', 'mcg', 'g', 'IU', '%', 'drops'];

// ─── Main Screen ──────────────────────────────────────────────────
class AddMedicineScreen extends StatefulWidget {
  final String currentUserId;
  const AddMedicineScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> with SingleTickerProviderStateMixin {
  int _step = 0; // 0 = type, 1 = details, 2 = schedule & stock
  late AnimationController _anim;
  late Animation<double> _fadeAnim;

  // Form data
  MedicineType _selectedType = MedicineType.pill;
  final _nameCtrl      = TextEditingController();
  final _amountCtrl    = TextEditingController();
  final _unitCtrl      = TextEditingController(text: 'mg');
  final _notesCtrl     = TextEditingController();
  final _stockCtrl     = TextEditingController();
  final _lowAlertCtrl  = TextEditingController();
  int _timesPerDay = 1; // frequency slider

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _nameCtrl.dispose(); _amountCtrl.dispose(); _unitCtrl.dispose();
    _notesCtrl.dispose(); _stockCtrl.dispose(); _lowAlertCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    _anim.reverse().then((_) {
      setState(() => _step++);
      _anim.forward();
    });
  }

  void _prevStep() {
    _anim.reverse().then((_) {
      setState(() => _step--);
      _anim.forward();
    });
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;
    final med = Medicine(
      id: const Uuid().v4(),
      userId: widget.currentUserId,
      name: _nameCtrl.text.trim(),
      description: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      dosageAmount: double.tryParse(_amountCtrl.text) ?? 1.0,
      dosageUnit: _unitCtrl.text.trim(),
      type: _selectedType,
      status: MedicineStatus.active,
      frequencyPerDay: _timesPerDay,
      stockQuantity: int.tryParse(_stockCtrl.text) ?? 0,
      lowStockThreshold: int.tryParse(_lowAlertCtrl.text) ?? 5,
    );
    context.read<MedicineBloc>().add(AddMedicine(med));
  }

  // ─── Step progress indicator ─────────────────────────────────────
  Widget _buildProgress() {
    final labels = ['Type', 'Details', 'Schedule'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < _step;
          final active = i == _step;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i > 0) Expanded(child: Container(height: 2, color: done || active ? AppTheme.primaryGreen : Colors.grey.shade300)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: active ? 32 : 26,
                      height: active ? 32 : 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? AppTheme.primaryGreen : (active ? AppTheme.primaryGreen : Colors.white),
                        border: Border.all(color: active || done ? AppTheme.primaryGreen : Colors.grey.shade300, width: 2),
                        boxShadow: active ? [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)] : [],
                      ),
                      child: Center(
                        child: done
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.grey)),
                      ),
                    ),
                    if (i < 2) Expanded(child: Container(height: 2, color: done ? AppTheme.primaryGreen : Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(labels[i], style: TextStyle(fontSize: 11, fontWeight: active ? FontWeight.bold : FontWeight.w400, color: active ? AppTheme.primaryGreen : AppTheme.textGrey)),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─── Step 0: Choose medicine type ───────────────────────────────
  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading('What kind of medicine?', 'Tap the one that looks like yours'),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85,
          ),
          itemCount: _typeOptions.length,
          itemBuilder: (ctx, i) {
            final opt = _typeOptions[i];
            final selected = _selectedType == opt.type;
            return GestureDetector(
              onTap: () => setState(() => _selectedType = opt.type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.primaryGreen.withOpacity(0.15) : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? AppTheme.primaryGreen : Colors.white.withOpacity(0.4), width: selected ? 2 : 1),
                  boxShadow: selected ? [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.2), blurRadius: 8, spreadRadius: 1)] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(opt.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 6),
                    Text(opt.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? AppTheme.primaryGreen : AppTheme.textDark)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        _buildNextButton('Continue →', _nextStep),
      ],
    );
  }

  // ─── Step 1: Name, Amount, Unit ──────────────────────────────────
  Widget _buildStep1() {
    final opted = _typeOptions.firstWhere((o) => o.type == _selectedType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading('Tell us about it', 'Just the basics — nothing complicated!'),
        const SizedBox(height: 24),
        _buildGlassField(
          controller: _nameCtrl,
          label: 'Medicine name',
          hint: 'e.g. Panadol, Lipitor…',
          icon: Text(opted.emoji, style: const TextStyle(fontSize: 22)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildGlassField(
                controller: _amountCtrl,
                label: 'How strong?',
                hint: 'e.g. 500',
                icon: const Icon(Icons.thermostat_outlined, color: AppTheme.primaryGreen),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildGlassField(
                controller: _unitCtrl,
                label: 'Unit',
                hint: 'mg',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Unit quick-picks
        Wrap(
          spacing: 8,
          children: _unitSuggestions.map((u) {
            final sel = _unitCtrl.text == u;
            return ActionChip(
              label: Text(u),
              backgroundColor: sel ? AppTheme.primaryGreen : Colors.white.withOpacity(0.7),
              labelStyle: TextStyle(fontSize: 13, color: sel ? Colors.white : AppTheme.textDark, fontWeight: sel ? FontWeight.bold : FontWeight.normal),
              side: BorderSide(color: sel ? AppTheme.primaryGreen : Colors.grey.shade300),
              onPressed: () => setState(() => _unitCtrl.text = u),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildGlassField(
          controller: _notesCtrl,
          label: 'Any notes? (Optional)',
          hint: 'e.g. Take with food, after meal…',
          icon: const Icon(Icons.sticky_note_2_outlined, color: AppTheme.textGrey),
          maxLines: 2,
        ),
        const SizedBox(height: 32),
        Row(children: [
          _buildBackButton(),
          const SizedBox(width: 12),
          Expanded(child: _buildNextButton('Continue →', _nameCtrl.text.isEmpty ? null : _nextStep)),
        ]),
      ],
    );
  }

  // ─── Step 2: Frequency + Stock ───────────────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading('When do you take it?', 'Slide to set how many times a day'),
        const SizedBox(height: 24),
        // Frequency visual slider
        _buildGlassContainer(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Times per day', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(20)),
                    child: Text('$_timesPerDay ×', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(trackHeight: 6, thumbColor: AppTheme.primaryGreen, activeTrackColor: AppTheme.primaryGreen, inactiveTrackColor: AppTheme.primaryGreen.withOpacity(0.2), overlayColor: AppTheme.primaryGreen.withOpacity(0.1)),
                child: Slider(
                  value: _timesPerDay.toDouble(),
                  min: 1, max: 6, divisions: 5,
                  onChanged: (v) => setState(() => _timesPerDay = v.round()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  final v = i + 1;
                  return Text('${v}x', style: TextStyle(fontSize: 11, color: v == _timesPerDay ? AppTheme.primaryGreen : AppTheme.textGrey, fontWeight: v == _timesPerDay ? FontWeight.bold : FontWeight.normal));
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildGlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('How many units do you have now?', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              const SizedBox(height: 4),
              const Text('We\'ll track your stock automatically', style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildGlassField(
                      controller: _stockCtrl,
                      label: 'Current quantity',
                      hint: 'e.g. 30',
                      icon: const Icon(Icons.inventory_2_outlined, color: AppTheme.primaryGreen),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGlassField(
                      controller: _lowAlertCtrl,
                      label: 'Alert me when below',
                      hint: 'e.g. 5',
                      icon: const Icon(Icons.notifications_outlined, color: Colors.orange),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        BlocBuilder<MedicineBloc, MedicineState>(
          builder: (ctx, state) {
            final isLoading = state is MedicineLoading;
            return Row(
              children: [
                _buildBackButton(),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _save,
                    icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.check_circle_outline),
                    label: const Text('Save Medicine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ─── Shared Widgets ───────────────────────────────────────────────
  Widget _buildHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 15, color: AppTheme.textGrey)),
      ],
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _buildGlassField(
      {required TextEditingController controller, required String label, String? hint, Widget? icon, int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Padding(padding: const EdgeInsets.all(12), child: icon) : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.4))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2)),
      ),
    );
  }

  Widget _buildNextButton(String label, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.grey.shade300 : AppTheme.primaryGreen,
        foregroundColor: onPressed == null ? AppTheme.textGrey : Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBackButton() {
    return OutlinedButton(
      onPressed: _prevStep,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(54, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.5)),
      ),
      child: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryGreen),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicineBloc, MedicineState>(
      listener: (ctx, state) {
        if (state is MedicineLoaded) Navigator.of(context).pop();
        if (state is MedicineError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 18, color: AppTheme.textDark),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.meshBackgroundGradient),
          child: SafeArea(
            child: Column(
              children: [
                _buildProgress(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _step == 0 ? _buildStep0() : _step == 1 ? _buildStep1() : _buildStep2(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
