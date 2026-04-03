import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

import 'features/schedule/data/datasources/schedule_local_data_source.dart';
import 'features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'features/schedule/data/repositories/schedule_repository_impl.dart';
import 'features/schedule/domain/repositories/schedule_repository.dart';

import 'features/dose_history/data/datasources/dose_history_local_data_source.dart';
import 'features/dose_history/data/datasources/dose_history_remote_data_source.dart';
import 'features/dose_history/data/repositories/dose_history_repository_impl.dart';
import 'features/dose_history/domain/repositories/dose_history_repository.dart';
import 'features/dose_history/data/usecases/generate_dose_history_usecase_impl.dart';

import 'features/user/data/datasources/user_remote_data_source.dart';
import 'features/user/data/repositories/auth_repository_impl.dart';
import 'features/user/domain/repositories/auth_repository.dart';

import 'features/medicine/presentation/bloc/medicine_bloc.dart';
import 'features/medicine/presentation/bloc/medicine_event.dart';
import 'features/user/presentation/bloc/auth_bloc.dart';
import 'features/user/presentation/bloc/auth_event.dart';
import 'features/user/presentation/bloc/auth_state.dart';
import 'features/schedule/presentation/bloc/schedule_bloc.dart';
import 'features/user/presentation/pages/login_screen.dart';
import 'features/user/presentation/pages/register_screen.dart';
import 'features/home/presentation/pages/main_layout_screen.dart';
import 'features/dose_history/presentation/bloc/dose_history_bloc.dart';
import 'features/home/presentation/bloc/dashboard_summary_bloc.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Timezones
  TimezoneHelper.init();

  // 2. Initialize Notifications
  final notificationService = NotificationService();
  await notificationService.init();

  // 3. Initialize Local Database (Isar)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [UserModelSchema, MedicineModelSchema, ScheduleModelSchema, DoseHistoryModelSchema],
    directory: dir.path,
  );

  // 4. Setup dependency injection
  final dio = Dio();
  // ignore: unused_local_variable
  final apiClient = ApiClient(dio); 
  
  const secureStorage = FlutterSecureStorage();
  
  // Repositories & DataSources
  final userRemoteDataSource = UserRemoteDataSource(dio);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: userRemoteDataSource,
    secureStorage: secureStorage,
  );

  final medicineRemoteDataSource = MedicineRemoteDataSource(dio);
  final medicineLocalDataSource = MedicineLocalDataSourceImpl(isar);
  final medicineRepository = MedicineRepositoryImpl(
    localDataSource: medicineLocalDataSource,
    remoteDataSource: medicineRemoteDataSource,
  );

  final scheduleRemoteDataSource = ScheduleRemoteDataSource(dio);
  final scheduleLocalDataSource = ScheduleLocalDataSourceImpl(isar);
  final scheduleRepository = ScheduleRepositoryImpl(
    localDataSource: scheduleLocalDataSource,
    remoteDataSource: scheduleRemoteDataSource,
  );

  final doseHistoryRemoteDataSource = DoseHistoryRemoteDataSource(dio);
  final doseHistoryLocalDataSource = DoseHistoryLocalDataSourceImpl(isar);
  final doseHistoryRepository = DoseHistoryRepositoryImpl(
    localDataSource: doseHistoryLocalDataSource,
    remoteDataSource: doseHistoryRemoteDataSource,
  );

  final generateDoseHistoryUseCase = GenerateDoseHistoryUseCaseImpl();

  runApp(RemindRxApp(
    medicineRepository: medicineRepository,
    authRepository: authRepository,
    scheduleRepository: scheduleRepository,
    doseHistoryRepository: doseHistoryRepository,
    generateDoseHistoryUseCase: generateDoseHistoryUseCase,
    notificationService: notificationService,
  ));
}

class RemindRxApp extends StatelessWidget {
  final MedicineRepository medicineRepository;
  final AuthRepository authRepository;
  final ScheduleRepository scheduleRepository;
  final DoseHistoryRepository doseHistoryRepository;
  final GenerateDoseHistoryUseCaseImpl generateDoseHistoryUseCase;
  final NotificationService notificationService;

  const RemindRxApp({
    Key? key,
    required this.medicineRepository,
    required this.authRepository,
    required this.scheduleRepository,
    required this.doseHistoryRepository,
    required this.generateDoseHistoryUseCase,
    required this.notificationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository: authRepository)..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => MedicineBloc(repository: medicineRepository),
        ),
        BlocProvider(
          create: (_) => ScheduleBloc(
            scheduleRepository: scheduleRepository,
            doseHistoryRepository: doseHistoryRepository,
            generateDoseHistoryUseCase: generateDoseHistoryUseCase,
            notificationService: notificationService,
          ),
        ),
        BlocProvider(
          create: (_) => DoseHistoryBloc(doseHistoryRepository: doseHistoryRepository),
        ),
        BlocProvider(
          create: (_) => DashboardSummaryBloc(
            doseHistoryRepository: doseHistoryRepository,
            medicineRepository: medicineRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'RemindRx',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
               // Load medicines for the authenticated user
               context.read<MedicineBloc>().add(LoadMedicines(state.user.id));
               return MainLayoutScreen(currentUserId: state.user.id);
            } else if (state is Unauthenticated || state is AuthError) {
              return const LoginScreen();
            }
            // Splash / Loading
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardRouter(),
        },
      ),
    );
  }
}

class DashboardRouter extends StatelessWidget {
  const DashboardRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return MainLayoutScreen(currentUserId: state.user.id);
        }
        return const LoginScreen();
      },
    );
  }
}
