import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/medicine.dart';
import '../bloc/medicine_bloc.dart';
import '../bloc/medicine_event.dart';

class AddMedicineScreen extends StatefulWidget {
  final String currentUserId;

  const AddMedicineScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dosageAmountController = TextEditingController();
  final _dosageUnitController = TextEditingController();
  final _frequencyPerDayController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  final _lowStockThresholdController = TextEditingController();

  MedicineType _selectedType = MedicineType.pill;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dosageAmountController.dispose();
    _dosageUnitController.dispose();
    _frequencyPerDayController.dispose();
    _stockQuantityController.dispose();
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  void _saveMedicine() {
    if (_formKey.currentState!.validate()) {
      final newMedicine = _createMedicineFromForm();
      
      // Dispatch the event to save the medicine
      context.read<MedicineBloc>().add(AddMedicine(newMedicine));

      // Show success message and pop
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine Added Successfully!')),
      );
      Navigator.of(context).pop();
    }
  }

  Medicine _createMedicineFromForm() {
    return _MedicineImpl(
      id: const Uuid().v4(),
      userId: widget.currentUserId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      dosageAmount: double.tryParse(_dosageAmountController.text) ?? 0.0,
      dosageUnit: _dosageUnitController.text.trim(),
      type: _selectedType,
      status: MedicineStatus.active,
      frequencyPerDay: int.tryParse(_frequencyPerDayController.text) ?? 1,
      stockQuantity: int.tryParse(_stockQuantityController.text) ?? 0,
      lowStockThreshold: int.tryParse(_lowStockThresholdController.text) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medication),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _dosageAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage (e.g. 500)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null) return 'Must be a number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _dosageUnitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit (mg, ml)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MedicineType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Medicine Type',
                  border: OutlineInputBorder(),
                ),
                items: MedicineType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _frequencyPerDayController,
                decoration: const InputDecoration(
                  labelText: 'Times Per Day',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.repeat),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockQuantityController,
                      decoration: const InputDecoration(
                        labelText: 'Current Stock',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Must be a number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lowStockThresholdController,
                      decoration: const InputDecoration(
                        labelText: 'Low Stock Threshold',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Must be a number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveMedicine,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Save Medicine', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicineImpl extends Medicine {
  const _MedicineImpl({
    required super.id,
    super.userId,
    required super.name,
    super.description,
    required super.dosageAmount,
    super.dosageUnit,
    required super.type,
    required super.status,
    required super.frequencyPerDay,
    required super.stockQuantity,
    required super.lowStockThreshold,
    super.notes,
  });
}
