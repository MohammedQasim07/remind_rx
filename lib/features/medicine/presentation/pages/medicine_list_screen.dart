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
import '../../../../core/utils/snackbar_helper.dart';
import 'package:remind_rx/l10n/app_localizations.dart';

class MedicineListScreen extends StatelessWidget {
  final String currentUserId;

  const MedicineListScreen({Key? key, required this.currentUserId})
      : super(key: key);

  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
        decoration:
            const BoxDecoration(gradient: AppTheme.meshBackgroundGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                _buildCabinetHeader(context),
                Expanded(
                  child: BlocBuilder<MedicineBloc, MedicineState>(
                    builder: (context, state) {
                      if (state is MedicineInitial ||
                          state is MedicineLoading) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: AppTheme.primaryGreen));
                      } else if (state is MedicineLoaded) {
                        if (state.medicines.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.primaryGreen.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.medication_outlined,
                                      size: 80,
                                      color: AppTheme.primaryGreen
                                          .withOpacity(0.5)),
                                ),
                                const SizedBox(height: 24),
                                Text(l10n.noDoses,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark)),
                                const SizedBox(height: 8),
                                Text(l10n.createAccount,
                                    style: const TextStyle(
                                        color: AppTheme.textGrey,
                                        fontSize: 16)),
                              ],
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 130),
                          itemCount: state.medicines.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final med = state.medicines[index];
                            return _buildPremiumMedicineCard(context, med);
                          },
                        );
                      } else if (state is MedicineError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: GlassCard(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline_rounded,
                                      color: Colors.orangeAccent, size: 64),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppTheme.textDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        AddMedicineScreen(currentUserId: currentUserId),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 6,
              icon: const Icon(Icons.add_rounded, size: 24),
              label: Text(l10n.addMedicine,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ));
  }

  Widget _buildCabinetHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.meds,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.5)),
          const SizedBox(height: 20),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppTheme.textGrey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.appTitle,
                      hintStyle: const TextStyle(color: AppTheme.textGrey),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Future: dispatch search event
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      color: AppTheme.primaryGreen),
                )
              ],
            ),
          )
        ],
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
        return {
          'icon': Icons.medical_services_rounded,
          'color': AppTheme.primaryGreen
        };
    }
  }

  Widget _buildPremiumMedicineCard(BuildContext context, Medicine med) {
    final l10n = AppLocalizations.of(context)!;
    final uiDetails = _getMedicineTypeUI(med.type);
    final Color medColor = uiDetails['color'];
    final IconData medIcon = uiDetails['icon'];

    final bool isLowStock = med.stockQuantity <= med.lowStockThreshold;

    return GlassCard(
      padding: const EdgeInsets.all(
          0), // We will handle padding inner for better structure
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
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                  letterSpacing: -0.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: medColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: medColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              med.type == MedicineType.other &&
                                      med.description != null &&
                                      med.description!.isNotEmpty
                                  ? med.description!.toUpperCase()
                                  : med.type.name.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: medColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${med.dosageAmount} ${_getLocalizedUnit(context, med.dosageUnit ?? med.type.name)} • ${med.frequencyPerDay} ${l10n.daily}',
                        style: const TextStyle(
                            color: AppTheme.textGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
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
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Inventory Info
                Row(
                  children: [
                    Icon(
                      isLowStock
                          ? Icons.warning_rounded
                          : Icons.inventory_2_rounded,
                      color: isLowStock ? Colors.orange : AppTheme.textGrey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${med.stockQuantity} ${l10n.dosesLeft}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isLowStock ? Colors.orange : AppTheme.textGrey,
                      ),
                    ),
                    if (isLowStock)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('LOW',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                      ),
                  ],
                ),

                // Actions
                Row(
                  children: [
                    InkWell(
                      onTap: () => _showRefillDialog(context, med),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.add_box_rounded,
                            color: Colors.blueAccent, size: 24),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => AddScheduleScreen(
                                  medicine: med, currentUserId: currentUserId)),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.alarm_add_rounded,
                            color: AppTheme.primaryGreen, size: 24),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => _showDeleteConfirmation(context, med.id),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.delete_outline_rounded,
                            color: Colors.red.withOpacity(0.6), size: 24),
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

  void _showRefillDialog(BuildContext context, Medicine med) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController amountController =
        TextEditingController(text: '10');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 24),
                Text(l10n.refillStockTitle,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        letterSpacing: -0.5)),
                const SizedBox(height: 8),
                Text(l10n.refillStockDesc,
                    style:
                        const TextStyle(color: AppTheme.textGrey, height: 1.5),
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickAddChip(
                        '+10',
                        () => amountController.text = '10',
                        AppTheme.primaryGreen),
                    _buildQuickAddChip('+30',
                        () => amountController.text = '30', Colors.blueAccent),
                    _buildQuickAddChip(
                        '+60',
                        () => amountController.text = '60',
                        Colors.orangeAccent),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.primaryGreen.withOpacity(0.05),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 24),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      elevation: 8,
                      shadowColor: AppTheme.primaryGreen.withOpacity(0.4),
                    ),
                    onPressed: () {
                      final parsedAmount =
                          int.tryParse(amountController.text) ?? 0;
                      if (parsedAmount <= 0) {
                        Navigator.pop(ctx);
                        return;
                      }
                      final updatedMedicine = med.copyWith(
                          stockQuantity: med.stockQuantity + parsedAmount);
                      context
                          .read<MedicineBloc>()
                          .add(UpdateMedicine(updatedMedicine));
                      Navigator.pop(ctx);
                      SnackbarHelper.showSuccess(
                          context,
                          l10n.stockAddedSuccess(parsedAmount, med.name,
                              updatedMedicine.stockQuantity));
                    },
                    child: Text(l10n.save,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAddChip(String label, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String medicineId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: Colors.redAccent, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.deleteMedicineTitle,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.deleteMedicineConfirm,
                  style: const TextStyle(
                      fontSize: 15, color: AppTheme.textGrey, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: AppTheme.textDark,
                        ),
                        child: Text(l10n.cancel,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<MedicineBloc>()
                              .add(DeleteMedicine(medicineId));
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(l10n.delete,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getLocalizedUnit(BuildContext context, String unit) {
    final l10n = AppLocalizations.of(context)!;
    if (unit.toLowerCase().contains('pill')) return l10n.unitPill;
    if (unit.toLowerCase().contains('mg')) return l10n.unitMg;
    if (unit.toLowerCase().contains('ml')) return l10n.unitMl;
    return unit;
  }
}
