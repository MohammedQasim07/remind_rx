import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/schedule.dart';
import '../../../medicine/domain/entities/medicine.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';

class AddScheduleScreen extends StatefulWidget {
  final Medicine medicine;
  final String currentUserId;

  const AddScheduleScreen({
    Key? key,
    required this.medicine,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  RepeatType _repeatType = RepeatType.daily;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? _startDate.add(const Duration(days: 30))),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _onSave() {
    final reminderDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _reminderTime.hour,
      _reminderTime.minute,
    );

    final newSchedule = Schedule(
      id: const Uuid().v4(),
      medicineId: widget.medicine.id,
      userId: widget.currentUserId,
      startDate: _startDate,
      endDate: _endDate,
      reminderTime: reminderDateTime,
      repeatType: _repeatType,
      notes: _notesController.text.trim(),
      isActive: true,
    );

    context.read<ScheduleBloc>().add(AddSchedule(newSchedule, widget.medicine));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.meshBackgroundGradient, // Apply global background explicitly here
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let gradient show
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Set Reminder', style: TextStyle(color: AppTheme.textDark)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppTheme.textDark),
        ),
        body: SafeArea(
          child: BlocListener<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              if (state is ScheduleLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Schedule created successfully!'),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
                Navigator.of(context).pop();
              } else if (state is ScheduleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMedicineInfo(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Reminders'),
                    const SizedBox(height: 16),
                    _buildTimePickerCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Duration & Frequency'),
                    const SizedBox(height: 16),
                    _buildFrequencySelector(),
                    const SizedBox(height: 16),
                    _buildDatePickerCard(),
                    const SizedBox(height: 32),
                    _buildNotesField(),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('ACTIVATE SCHEDULE', style: TextStyle(letterSpacing: 1.0)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineInfo() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.vaccines, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.medicine.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
                Text(
                  '${widget.medicine.dosageAmount} ${widget.medicine.dosageUnit ?? widget.medicine.type.name}',
                  style: const TextStyle(color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildTimePickerCard() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      onTap: () => _selectTime(context),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, color: AppTheme.primaryGreen),
          const SizedBox(width: 16),
          const Text('Pick Time', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
          const Spacer(),
          Text(
            _reminderTime.format(context),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RepeatType>(
          value: _repeatType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryGreen),
          dropdownColor: Colors.white,
          onChanged: (v) => setState(() => _repeatType = v!),
          items: RepeatType.values.where((e) => e != RepeatType.none).map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text('Every ${type.name.capitalize()}', style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDatePickerCard() {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            onTap: () => _selectDate(context, true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Start Date', style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(_startDate),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            onTap: () => _selectDate(context, false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ends (Optional)', style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                const SizedBox(height: 4),
                Text(
                  _endDate != null ? DateFormat('MMM dd, yyyy').format(_endDate!) : 'Infinite',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 2,
      style: const TextStyle(color: AppTheme.textDark),
      decoration: InputDecoration(
        labelText: 'Notes',
        hintText: 'e.g. Take with food',
        labelStyle: const TextStyle(color: AppTheme.textGrey),
        hintStyle: TextStyle(color: AppTheme.textGrey.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
