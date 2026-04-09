import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/medicine.dart';
import '../bloc/medicine_bloc.dart';
import '../bloc/medicine_state.dart';
import '../bloc/medicine_event.dart';
import 'add_medicine_screen.dart';
import '../../../schedule/presentation/pages/add_schedule_screen.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';

class MedicineListScreen extends StatelessWidget {
  final String currentUserId;

  const MedicineListScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Cabinet', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<MedicineBloc, MedicineState>(
        builder: (context, state) {
          if (state is MedicineInitial || state is MedicineLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen));
          } else if (state is MedicineLoaded) {
            if (state.medicines.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.medication_outlined, size: 80, color: AppTheme.primaryGreen.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 24),
                    const Text('Your cabinet is empty', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    const SizedBox(height: 8),
                    const Text('Tap the + button to add medications', style: TextStyle(color: AppTheme.textGrey, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 130),
              itemCount: state.medicines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final med = state.medicines[index];
                return _buildPremiumMedicineCard(context, med);
              },
            );
          } else if (state is MedicineError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddMedicineScreen(currentUserId: currentUserId),
              ),
            );
          },
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 6,
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text('Add Medicine', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Map<String, dynamic> _getMedicineTypeUI(MedicineType type) {
    switch (type) {
      case MedicineType.capsule:
      case MedicineType.pill:
        return {'icon': Icons.medication_rounded, 'color': Colors.blueAccent};
      case MedicineType.liquid:
      case MedicineType.drops:
        return {'icon': Icons.water_drop_rounded, 'color': Colors.teal};
      case MedicineType.injection:
        return {'icon': Icons.vaccines_rounded, 'color': Colors.purpleAccent};
      case MedicineType.inhaler:
        return {'icon': Icons.air_rounded, 'color': Colors.orangeAccent};
      case MedicineType.cream:
        return {'icon': Icons.healing_rounded, 'color': Colors.pinkAccent};
      case MedicineType.other:
      default:
        return {'icon': Icons.medical_services_rounded, 'color': AppTheme.primaryGreen};
    }
  }

  Widget _buildPremiumMedicineCard(BuildContext context, Medicine med) {
    final uiDetails = _getMedicineTypeUI(med.type);
    final Color medColor = uiDetails['color'];
    final IconData medIcon = uiDetails['icon'];

    final bool isLowStock = med.stockQuantity <= med.lowStockThreshold;

    return GlassCard(
      padding: const EdgeInsets.all(0), // We will handle padding inner for better structure
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Upper Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: medColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(medIcon, color: medColor, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              med.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark, letterSpacing: -0.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: medColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: medColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              med.type.name.toUpperCase(),
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: medColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${med.dosageAmount} ${med.dosageUnit ?? med.type.name} • ${med.frequencyPerDay} times daily',
                        style: const TextStyle(color: AppTheme.textGrey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Container(height: 1, color: AppTheme.textGrey.withOpacity(0.1)),
          
          // Lower Section (Inventory & Actions)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Inventory Info
                Row(
                  children: [
                    Icon(
                      isLowStock ? Icons.warning_rounded : Icons.inventory_2_rounded,
                      color: isLowStock ? Colors.orange : AppTheme.textGrey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${med.stockQuantity} remaining',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isLowStock ? Colors.orange : AppTheme.textGrey,
                      ),
                    ),
                    if (isLowStock)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('LOW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
                      ),
                  ],
                ),
                
                // Actions
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddScheduleScreen(medicine: med, currentUserId: currentUserId)),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.alarm_add_rounded, color: AppTheme.primaryGreen, size: 24),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => context.read<MedicineBloc>().add(DeleteMedicine(med.id)),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.delete_outline_rounded, color: Colors.red.withOpacity(0.6), size: 24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
