import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'core/network/api_client.dart';
import 'core/services/notification_service.dart';
import 'core/utils/timezone_helper.dart';

import 'features/user/data/models/user_model.dart';
import 'features/medicine/data/models/medicine_model.dart';
import 'features/schedule/data/models/schedule_model.dart';
import 'features/dose_history/data/models/dose_history_model.dart';

import 'features/medicine/data/datasources/medicine_local_data_source.dart';
import 'features/medicine/data/datasources/medicine_remote_data_source.dart';
import 'features/medicine/data/repositories/medicine_repository_impl.dart';
import 'features/medicine/domain/repositories/medicine_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'features/user/data/datasources/user_remote_data_source.dart';
import 'features/user/data/repositories/auth_repository_impl.dart';
import 'features/user/domain/repositories/auth_repository.dart';
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

  // 4. Setup dependency injection manually
  final dio = Dio();
  // ignore: unused_local_variable
  final apiClient = ApiClient(dio); // Initializes base URL and interceptors
  
  const secureStorage = FlutterSecureStorage();
  
  final UserRemoteDataSource userRemoteDataSource = UserRemoteDataSource(dio);
  final AuthRepository authRepository = AuthRepositoryImpl(
    remoteDataSource: userRemoteDataSource,
    secureStorage: secureStorage,
  );

  final MedicineRemoteDataSource medicineRemoteDataSource = MedicineRemoteDataSource(dio);
  final MedicineLocalDataSource medicineLocalDataSource = MedicineLocalDataSourceImpl(isar);
  
  final MedicineRepository medicineRepository = MedicineRepositoryImpl(
    localDataSource: medicineLocalDataSource,
    remoteDataSource: medicineRemoteDataSource,
  );

  runApp(RemindRxApp(
    medicineRepository: medicineRepository,
    authRepository: authRepository,
  ));
}

class RemindRxApp extends StatelessWidget {
  final MedicineRepository medicineRepository;
  final AuthRepository authRepository;

  const RemindRxApp({
    Key? key,
    required this.medicineRepository,
    required this.authRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MedicineBloc(repository: medicineRepository)..add(const LoadMedicines('user_1')),
        ),
      ],
      child: MaterialApp(
        title: 'RemindRx',
        /*
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ar', ''), // Arabic
        ],
        */
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        // In a full implementation, we would use a Bloc to check auth status and return Login or Home
        home: const MainLayoutScreen(currentUserId: 'user_1'),
      ),
    );
  }
}
