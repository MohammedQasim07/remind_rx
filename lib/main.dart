import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/services/notification_service.dart';
import 'core/utils/timezone_helper.dart';

import 'features/user/data/models/user_model.dart';
import 'features/medicine/data/models/medicine_model.dart';
import 'features/schedule/data/models/schedule_model.dart';
import 'features/dose_history/data/models/dose_history_model.dart';

import 'features/medicine/data/datasources/medicine_local_data_source.dart';
import 'features/medicine/data/repositories/medicine_repository_impl.dart';
import 'features/medicine/domain/repositories/medicine_repository.dart';
import 'features/medicine/presentation/bloc/medicine_bloc.dart';
import 'features/medicine/presentation/bloc/medicine_event.dart';
import 'features/medicine/presentation/pages/medicine_list_screen.dart';
import 'features/home/presentation/pages/main_layout_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Timezones
  TimezoneHelper.init();

  // 2. Initialize Notifications
  await NotificationService().init();

  // 3. Initialize Local Database (Isar)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [UserModelSchema, MedicineModelSchema, ScheduleModelSchema, DoseHistoryModelSchema],
    directory: dir.path,
  );

  // 4. Setup dependency injection manually (or adapt for get_it later)
  final MedicineLocalDataSource medicineLocalDataSource = MedicineLocalDataSourceImpl(isar);
  final MedicineRepository medicineRepository = MedicineRepositoryImpl(medicineLocalDataSource);

  runApp(RemindRxApp(medicineRepository: medicineRepository));
}

class RemindRxApp extends StatelessWidget {
  final MedicineRepository medicineRepository;

  const RemindRxApp({Key? key, required this.medicineRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // For demo purposes, we automatically load medicines for a demo user "user_1"
          create: (_) => MedicineBloc(repository: medicineRepository)..add(const LoadMedicines('user_1')),
        ),
      ],
      child: MaterialApp(
        title: 'RemindRx',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const MainLayoutScreen(currentUserId: 'user_1'),
      ),
    );
  }
}
