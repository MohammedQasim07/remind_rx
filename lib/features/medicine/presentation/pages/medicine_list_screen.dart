import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/medicine_bloc.dart';
import '../bloc/medicine_state.dart';
import '../bloc/medicine_event.dart';
import 'add_medicine_screen.dart';
import '../../../schedule/presentation/pages/add_schedule_screen.dart';
import '../../../../core/theme/app_theme.dart';

class MedicineListScreen extends StatelessWidget {
  final String currentUserId;

  const MedicineListScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Medicines'),
      ),
      body: BlocBuilder<MedicineBloc, MedicineState>(
        builder: (context, state) {
          if (state is MedicineInitial || state is MedicineLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MedicineLoaded) {
            if (state.medicines.isEmpty) {
              return const Center(child: Text('No medicines found. Tap + to add.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
              itemCount: state.medicines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final med = state.medicines[index];
                return _buildMedicineCard(context, med);
              },
            );
          } else if (state is MedicineError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Higher padding to clear the floating island
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddMedicineScreen(currentUserId: currentUserId),
              ),
            );
          },
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(BuildContext context, dynamic med) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  '${med.dosageAmount} ${med.dosageUnit ?? med.type.name} • ${med.frequencyPerDay} times daily',
                  style: const TextStyle(color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.alarm_add, color: AppTheme.primaryGreen),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddScheduleScreen(
                    medicine: med,
                    currentUserId: currentUserId,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.withOpacity(0.6)),
            onPressed: () {
              context.read<MedicineBloc>().add(DeleteMedicine(med.id));
            },
          ),
        ],
      ),
    );
  }
}
