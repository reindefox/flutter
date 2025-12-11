import 'package:get_it/get_it.dart';

import 'package:project/data/datasources/local/container_local_datasource.dart';
import 'package:project/data/datasources/local/service_local_datasource.dart';
import 'package:project/data/datasources/local/ping_local_datasource.dart';
import 'package:project/data/datasources/local/metrics_local_datasource.dart';
import 'package:project/data/datasources/local/user_local_datasource.dart';
import 'package:project/data/datasources/local/log_local_datasource.dart';

import 'package:project/domain/repositories/container_repository.dart';
import 'package:project/domain/repositories/service_repository.dart';
import 'package:project/domain/repositories/ping_repository.dart';
import 'package:project/domain/repositories/metrics_repository.dart';
import 'package:project/domain/repositories/user_repository.dart';
import 'package:project/domain/repositories/log_repository.dart';

import 'package:project/data/repositories/container_repository_impl.dart';
import 'package:project/data/repositories/service_repository_impl.dart';
import 'package:project/data/repositories/ping_repository_impl.dart';
import 'package:project/data/repositories/metrics_repository_impl.dart';
import 'package:project/data/repositories/user_repository_impl.dart';
import 'package:project/data/repositories/log_repository_impl.dart';

import 'package:project/domain/usecases/container_usecases.dart';
import 'package:project/domain/usecases/service_usecases.dart';
import 'package:project/domain/usecases/ping_usecases.dart';
import 'package:project/domain/usecases/metrics_usecases.dart';
import 'package:project/domain/usecases/user_usecases.dart';
import 'package:project/domain/usecases/log_usecases.dart';
import 'package:project/core/services/auth_service.dart';
import 'package:project/core/services/secure_storage_service.dart';
import 'package:project/core/services/settings_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  getIt.registerLazySingleton<SettingsService>(
    () => SettingsService(),
  );

  getIt.registerLazySingleton<ContainerLocalDataSource>(
    () => ContainerLocalDataSource(),
  );
  getIt.registerLazySingleton<ServiceLocalDataSource>(
    () => ServiceLocalDataSource(),
  );
  getIt.registerLazySingleton<PingLocalDataSource>(
    () => PingLocalDataSource(),
  );
  getIt.registerLazySingleton<MetricsLocalDataSource>(
    () => MetricsLocalDataSource(),
  );
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(),
  );
  getIt.registerLazySingleton<LogLocalDataSource>(
    () => LogLocalDataSource(),
  );

  getIt.registerLazySingleton<ContainerRepository>(
    () => ContainerRepositoryImpl(getIt<ContainerLocalDataSource>()),
  );
  getIt.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(getIt<ServiceLocalDataSource>()),
  );
  getIt.registerLazySingleton<PingRepository>(
    () => PingRepositoryImpl(getIt<PingLocalDataSource>()),
  );
  getIt.registerLazySingleton<MetricsRepository>(
    () => MetricsRepositoryImpl(getIt<MetricsLocalDataSource>()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserLocalDataSource>()),
  );
  getIt.registerLazySingleton<LogRepository>(
    () => LogRepositoryImpl(getIt<LogLocalDataSource>()),
  );

  getIt.registerFactory(() => GetContainersUseCase(getIt<ContainerRepository>()));
  getIt.registerFactory(() => GetAvailableContainersUseCase(getIt<ContainerRepository>()));
  getIt.registerFactory(() => AddAvailableContainerUseCase(getIt<ContainerRepository>()));
  getIt.registerFactory(() => AddContainerToManagedUseCase(getIt<ContainerRepository>()));
  getIt.registerFactory(() => StartContainerUseCase(getIt<ContainerRepository>()));
  getIt.registerFactory(() => StopContainerUseCase(getIt<ContainerRepository>()));
  getIt.registerFactory(() => RemoveContainerUseCase(getIt<ContainerRepository>()));

  getIt.registerFactory(() => GetServicesUseCase(getIt<ServiceRepository>()));
  getIt.registerFactory(() => GetAvailableServicesUseCase(getIt<ServiceRepository>()));
  getIt.registerFactory(() => AddAvailableServiceUseCase(getIt<ServiceRepository>()));
  getIt.registerFactory(() => AddServiceToManagedUseCase(getIt<ServiceRepository>()));
  getIt.registerFactory(() => StartServiceUseCase(getIt<ServiceRepository>()));
  getIt.registerFactory(() => StopServiceUseCase(getIt<ServiceRepository>()));
  getIt.registerFactory(() => RemoveServiceUseCase(getIt<ServiceRepository>()));

  getIt.registerFactory(() => GetPingHistoryUseCase(getIt<PingRepository>()));
  getIt.registerFactory(() => SendPingUseCase(getIt<PingRepository>()));
  getIt.registerFactory(() => RemovePingUseCase(getIt<PingRepository>()));
  getIt.registerFactory(() => ClearPingHistoryUseCase(getIt<PingRepository>()));

  getIt.registerFactory(() => GetCurrentMetricsUseCase(getIt<MetricsRepository>()));
  getIt.registerFactory(() => StartMetricsMonitoringUseCase(getIt<MetricsRepository>()));
  getIt.registerFactory(() => StopMetricsMonitoringUseCase(getIt<MetricsRepository>()));

  getIt.registerFactory(() => GetCurrentUserUseCase(getIt<UserRepository>()));
  getIt.registerFactory(() => UpdateCurrentUserUseCase(getIt<UserRepository>()));
  getIt.registerFactory(() => GetAllUsersUseCase(getIt<UserRepository>()));
  getIt.registerFactory(() => AddUserUseCase(getIt<UserRepository>()));
  getIt.registerFactory(() => UpdateUserUseCase(getIt<UserRepository>()));
  getIt.registerFactory(() => DeleteUserUseCase(getIt<UserRepository>()));
  getIt.registerFactory(() => ToggleUserStatusUseCase(getIt<UserRepository>()));

  getIt.registerFactory(() => GetAllLogsUseCase(getIt<LogRepository>()));
  getIt.registerFactory(() => GetLogsByTypeUseCase(getIt<LogRepository>()));
  getIt.registerFactory(() => AddLogEntryUseCase(getIt<LogRepository>()));

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<SecureStorageService>()),
  );
}
