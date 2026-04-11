import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/premium_time_picker.dart';
import '../../domain/entities/medicine.dart';
import '../bloc/medicine_bloc.dart';
import '../bloc/medicine_event.dart';
import '../bloc/medicine_state.dart';
import '../../../schedule/domain/entities/schedule.dart';
import 'package:remind_rx/l10n/app_localizations.dart';

// ─── Type Interface ─────────────────────────────────────────────
class _MedicineTypeOption {
  final MedicineType type;
  final IconData icon;
  final Color color;
  final String label;

  const _MedicineTypeOption({
    required this.type,
    required this.icon,
    required this.color,
    required this.label,
  });
}

List<_MedicineTypeOption> _getTypeOptions(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    _MedicineTypeOption(type: MedicineType.pill, icon: Icons.medication_rounded, color: Colors.blueAccent, label: l10n.pill),
    _MedicineTypeOption(type: MedicineType.capsule, icon: Icons.medication_liquid_rounded, color: Colors.indigo, label: l10n.capsule),
    _MedicineTypeOption(type: MedicineType.liquid, icon: Icons.water_drop_rounded, color: Colors.teal, label: l10n.liquid),
    _MedicineTypeOption(type: MedicineType.injection, icon: Icons.vaccines_rounded, color: Colors.purpleAccent, label: l10n.injection),
    _MedicineTypeOption(type: MedicineType.inhaler, icon: Icons.air_rounded, color: Colors.orangeAccent, label: l10n.inhaler),
    _MedicineTypeOption(type: MedicineType.drops, icon: Icons.opacity_rounded, color: Colors.lightBlue, label: l10n.drops),
    _MedicineTypeOption(type: MedicineType.cream, icon: Icons.healing_rounded, color: Colors.pinkAccent, label: l10n.cream),
    _MedicineTypeOption(type: MedicineType.other, icon: Icons.medical_services_rounded, color: AppTheme.primaryGreen, label: l10n.other),
  ];
}

// ─── Dynamic Vocabulary Logic ───────────────────────────────────
class _MedicineVocabulary {
  final String amountLabel;
  final String stockLabel;
  final String frequencyLabel;
  final List<String> unitSuggestions;

  const _MedicineVocabulary({
    required this.amountLabel,
    required this.stockLabel,
    required this.frequencyLabel,
    required this.unitSuggestions,
  });
}

_MedicineVocabulary _getVocabularyForType(BuildContext context, MedicineType type) {
  final l10n = AppLocalizations.of(context)!;
  switch (type) {
    case MedicineType.cream:
      return _MedicineVocabulary(
        amountLabel: l10n.amountCream,
        stockLabel: l10n.stockCream,
        frequencyLabel: l10n.freqCream,
        unitSuggestions: ['g', 'mg', '%'],
      );
    case MedicineType.drops:
      return _MedicineVocabulary(
        amountLabel: l10n.amountDrops,
        stockLabel: l10n.stockDrops,
        frequencyLabel: l10n.freqDrops,
        unitSuggestions: ['ml'],
      );
    case MedicineType.injection:
      return _MedicineVocabulary(
        amountLabel: l10n.amountInjection,
        stockLabel: l10n.stockInjection,
        frequencyLabel: l10n.freqInjection,
        unitSuggestions: ['ml', 'IU', 'mg'],
      );
    case MedicineType.liquid:
      return _MedicineVocabulary(
        amountLabel: l10n.amountLiquid,
        stockLabel: l10n.stockLiquid,
        frequencyLabel: l10n.freqLiquid,
        unitSuggestions: ['ml'],
      );
    case MedicineType.inhaler:
      return _MedicineVocabulary(
        amountLabel: l10n.amountInhaler,
        stockLabel: l10n.stockInhaler,
        frequencyLabel: l10n.freqInhaler,
        unitSuggestions: ['mcg'],
      );
    case MedicineType.pill:
    case MedicineType.capsule:
      return _MedicineVocabulary(
        amountLabel: l10n.amountPill,
        stockLabel: l10n.stockPill,
        frequencyLabel: l10n.freqPill,
        unitSuggestions: ['mg', 'g'],
      );
    case MedicineType.other:
    default:
      return _MedicineVocabulary(
        amountLabel: l10n.genericAmountLabel,
        stockLabel: l10n.genericStockLabel,
        frequencyLabel: l10n.genericFreqLabel,
        unitSuggestions: ['mg', 'ml', 'unit'],
      );
  }
}

// ─── Main Screen ────────────────────────────────────────────────
class AddMedicineScreen extends StatefulWidget {
  final String currentUserId;
  const AddMedicineScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> with SingleTickerProviderStateMixin {
  int _step = 0; // 0 = Type, 1 = Details, 2 = Schedule & Stock
  late AnimationController _anim;
  late Animation<double> _fadeAnim;

  MedicineType _selectedType = MedicineType.pill;
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _unitCtrl = TextEditingController(text: 'pill(s)');
  final _notesCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _lowAlertCtrl = TextEditingController();
  final _customTypeCtrl = TextEditingController();

  int _timesPerDay = 1;
  List<TimeOfDay> _reminderTimes = [const TimeOfDay(hour: 8, minute: 0)];

  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _unitCtrl.dispose();
    _notesCtrl.dispose();
    _stockCtrl.dispose();
    _lowAlertCtrl.dispose();
    _customTypeCtrl.dispose();
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

  void _updateFrequency(int value) {
    setState(() {
      _timesPerDay = value;
      _reminderTimes.clear();
      if (value == 1) {
        _reminderTimes = [const TimeOfDay(hour: 8, minute: 0)];
      } else if (value == 2) {
        _reminderTimes = [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 20, minute: 0)];
      } else if (value == 3) {
        _reminderTimes = [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 14, minute: 0), const TimeOfDay(hour: 20, minute: 0)];
      } else if (value == 4) {
        _reminderTimes = [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 12, minute: 0), const TimeOfDay(hour: 16, minute: 0), const TimeOfDay(hour: 20, minute: 0)];
      } else {
        for (int i = 0; i < value; i++) {
          _reminderTimes.add(TimeOfDay(hour: 8 + (i * 2), minute: 0));
        }
      }
    });
  }

  Future<void> _pickTimeForIndex(int index) async {
    final TimeOfDay? picked = await PremiumTimePicker.show(
      context,
      initialTime: _reminderTimes[index],
    );
    if (picked != null) {
      setState(() {
        _reminderTimes[index] = picked;
      });
    }
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;

    final String medId = const Uuid().v4();
    final med = Medicine(
      id: medId,
      userId: widget.currentUserId,
      name: _nameCtrl.text.trim(),
      description: _selectedType == MedicineType.other && _customTypeCtrl.text.isNotEmpty 
          ? _customTypeCtrl.text.trim() 
          : (_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
      dosageAmount: double.tryParse(_amountCtrl.text) ?? 1.0,
      dosageUnit: _unitCtrl.text.trim(),
      type: _selectedType,
      status: MedicineStatus.active,
      frequencyPerDay: _timesPerDay,
      stockQuantity: int.tryParse(_stockCtrl.text) ?? 0,
      lowStockThreshold: int.tryParse(_lowAlertCtrl.text) ?? 5,
      notes: _notesCtrl.text.trim(),
    );

    final now = DateTime.now();
    List<Schedule> builtSchedules = [];
    for (var time in _reminderTimes) {
      final scheduleTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      final schedule = Schedule(
        id: const Uuid().v4(),
        medicineId: medId,
        userId: widget.currentUserId,
        startDate: now,
        endDate: null,
        reminderTime: scheduleTime,
        repeatType: RepeatType.daily,
        isActive: true,
        notes: "Auto-generated from Medicine Wizard",
      );
      builtSchedules.add(schedule);
    }
    
    context.read<MedicineBloc>().add(SaveCompleteMedicineBundle(med, builtSchedules));
  }

  // ─── UI ─────────────────────────────────────────────────────────
  Widget _buildProgress() {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.details, l10n.dosage, l10n.remindersLabel];
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
                    if (i > 0) Expanded(child: Container(height: 3, color: done || active ? AppTheme.primaryGreen : Colors.white.withOpacity(0.5))),
                    GestureDetector(
                      onTap: () {
                        if (i < _step) {
                          _anim.reverse().then((_) {
                            setState(() => _step = i);
                            _anim.forward();
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: active ? 36 : 28,
                        height: active ? 36 : 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done ? AppTheme.primaryGreen : (active ? AppTheme.primaryGreen : Colors.white.withOpacity(0.6)),
                          border: Border.all(color: active || done ? Colors.white : Colors.transparent, width: 3),
                          boxShadow: active ? [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.4), blurRadius: 10)] : [],
                        ),
                        child: Center(
                          child: done
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: active ? Colors.white : AppTheme.textGrey)),
                        ),
                      ),
                    ),
                    if (i < 2) Expanded(child: Container(height: 3, color: done ? AppTheme.primaryGreen : Colors.white.withOpacity(0.5))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(labels[i], style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.w600, color: active ? AppTheme.primaryGreen : AppTheme.textGrey)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep0() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading(l10n.medicines, l10n.pleaseLogin),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: _getTypeOptions(context).length,
          itemBuilder: (ctx, i) {
            final typeOptions = _getTypeOptions(context);
            final opt = typeOptions[i];
            final selected = _selectedType == opt.type;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = opt.type;
                  // Dynamic Unit default:
                  _unitCtrl.text = _getVocabularyForType(context, opt.type).unitSuggestions.first;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: selected ? opt.color.withOpacity(0.15) : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: selected ? opt.color : Colors.white.withOpacity(0.5), width: 1.5),
                  boxShadow: selected ? [BoxShadow(color: opt.color.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))] : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(opt.icon, size: 38, color: selected ? opt.color : AppTheme.textGrey.withOpacity(0.8)),
                        const SizedBox(height: 12),
                        Text(
                          opt.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                            color: selected ? opt.color : AppTheme.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 48),
        _buildStepButton(label: l10n.stepDetails, icon: Icons.arrow_forward_rounded, onPressed: _nextStep, isPrimary: true),
      ],
    );
  }

  Widget _buildStep1() {
    final l10n = AppLocalizations.of(context)!;
    final typeOptions = _getTypeOptions(context);
    final opted = typeOptions.firstWhere((o) => o.type == _selectedType);
    final vocab = _getVocabularyForType(context, _selectedType);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading(l10n.dosage, l10n.medicineName),
        const SizedBox(height: 32),
        _buildUltraPremiumField(
          controller: _nameCtrl,
          label: l10n.medicineName,
          icon: Icon(opted.icon, color: opted.color),
        ),
        if (_selectedType == MedicineType.other) ...[
          const SizedBox(height: 16),
          _buildUltraPremiumField(
            controller: _customTypeCtrl,
            label: l10n.customMedicineTypeLabel,
            icon: Icon(opted.icon, color: opted.color),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildUltraPremiumField(
                controller: _amountCtrl,
                label: vocab.amountLabel,
                icon: const Icon(Icons.flash_on_rounded, color: Colors.amber),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildUltraPremiumField(
                controller: _unitCtrl,
                label: l10n.unit,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: vocab.unitSuggestions.map((u) {
            final sel = _unitCtrl.text == u;
            return GestureDetector(
              onTap: () => setState(() => _unitCtrl.text = u),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                opacity: sel ? 1.0 : 0.4,
                child: Text(
                  u,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: sel ? AppTheme.primaryGreen : AppTheme.textGrey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _buildUltraPremiumField(
          controller: _notesCtrl,
          label: l10n.specialNotes,
          icon: const Icon(Icons.info_outline_rounded, color: AppTheme.textGrey),
          maxLines: 2,
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            _buildBackButton(),
            const SizedBox(width: 16),
            Expanded(
              flex: 4, 
              child: _buildStepButton(label: l10n.tracker, icon: Icons.schedule_rounded, onPressed: _nameCtrl.text.isEmpty ? null : _nextStep, isPrimary: true)
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    final l10n = AppLocalizations.of(context)!;
    final vocab = _getVocabularyForType(context, _selectedType);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading(l10n.frequencyQuestion, l10n.frequencyDesc),
        const SizedBox(height: 24),
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(vocab.frequencyLabel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Text(l10n.timesPerDayLabel(_timesPerDay), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 8, 
                  thumbColor: AppTheme.primaryGreen, 
                  activeTrackColor: AppTheme.primaryGreen, 
                  inactiveTrackColor: AppTheme.primaryGreen.withOpacity(0.15)
                ),
                child: Slider(
                  value: _timesPerDay.toDouble(),
                  min: 1, max: 6, divisions: 5,
                  onChanged: (v) => _updateFrequency(v.round()),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(height: 1, thickness: 1)),
              Text(l10n.atWhatTimes, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5)),
              const SizedBox(height: 16),
              Column(
                children: List.generate(_reminderTimes.length, (index) {
                  return GestureDetector(
                    onTap: () => _pickTimeForIndex(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.notifications_active_rounded, color: AppTheme.primaryGreen, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Text(AppLocalizations.of(context)!.doseN(index + 1), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          const Spacer(),
                          Text(
                            _reminderTimes[index].format(context),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildUltraPremiumField(
                controller: _stockCtrl,
                label: vocab.stockLabel,
                icon: const Icon(Icons.inventory_2_rounded, color: Colors.blueAccent),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildUltraPremiumField(
                controller: _lowAlertCtrl,
                label: l10n.lowStockAlert,
                icon: const Icon(Icons.warning_rounded, color: Colors.orange),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        BlocBuilder<MedicineBloc, MedicineState>(
          builder: (ctx, state) {
            final isLoading = state is MedicineLoading;
            return Row(
              children: [
                _buildBackButton(),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: _buildStepButton(
                    label: l10n.save,
                    icon: Icons.double_arrow_rounded,
                    onPressed: isLoading ? null : _save,
                    isPrimary: true,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ─── Ultra Premium UI Builders ──────────────────────────────────
  Widget _buildHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.textDark, letterSpacing: -1.2)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(fontSize: 16, color: AppTheme.textGrey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildUltraPremiumField({required TextEditingController controller, required String label, Widget? icon, int maxLines = 1, TextInputType? keyboardType}) {
    return GlassCard(
      padding: EdgeInsets.zero,
      opacity: 0.5,
      blur: 20,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textGrey),
          prefixIcon: icon != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: icon) : null,
          filled: true,
          fillColor: Colors.transparent, // True glass effect
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2)),
          contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildStepButton({required String label, required IconData icon, required VoidCallback? onPressed, required bool isPrimary}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.grey.shade400 : (isPrimary ? AppTheme.primaryGreen : Colors.white),
        foregroundColor: onPressed == null ? Colors.white : (isPrimary ? Colors.white : AppTheme.primaryGreen),
        elevation: isPrimary ? 8 : 0,
        shadowColor: AppTheme.primaryGreen.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(width: 8),
          Icon(icon, size: 22),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Expanded(
      flex: 2,
      child: ElevatedButton(
        onPressed: _prevStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.4),
          foregroundColor: AppTheme.textDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withOpacity(0.8), width: 1.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            const SizedBox(width: 6),
            Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MedicineBloc, MedicineState>(
          listener: (ctx, state) {
            if (state is MedicineLoaded) {
              Navigator.of(context).pop();
            }
            if (state is MedicineError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: GlassCard(padding: const EdgeInsets.all(10), opacity: 0.8, child: const Icon(Icons.close_rounded, color: AppTheme.textDark, size: 20)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
