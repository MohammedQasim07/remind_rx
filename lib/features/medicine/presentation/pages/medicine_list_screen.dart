import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/medicine_bloc.dart';
import '../bloc/medicine_state.dart';
import '../bloc/medicine_event.dart';
import 'add_medicine_screen.dart';

class MedicineListScreen extends StatelessWidget {
  final String currentUserId; // For demonstration.

  const MedicineListScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
      ),
      body: BlocBuilder<MedicineBloc, MedicineState>(
        builder: (context, state) {
          if (state is MedicineInitial) {
            return const Center(child: Text('Please wait...'));
          } else if (state is MedicineLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MedicineLoaded) {
            if (state.medicines.isEmpty) {
              return const Center(child: Text('No medicines found. Tap + to add.'));
            }
            return ListView.builder(
              itemCount: state.medicines.length,
              itemBuilder: (context, index) {
                final med = state.medicines[index];
                return ListTile(
                  title: Text(med.name),
                  subtitle: Text('\${med.dosage} \${med.type.name} - \${med.frequency}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<MedicineBloc>().add(DeleteMedicine(med.id));
                    },
                  ),
                );
              },
            );
          } else if (state is MedicineError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddMedicineScreen(currentUserId: currentUserId), // pass ID
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
