import 'package:get_it/get_it.dart';
import 'package:project/shared/state/ping_state.dart';
import 'package:project/shared/state/container_state.dart';
import 'package:project/shared/state/service_state.dart';
import 'package:project/shared/state/metrics_state.dart';
import 'package:project/shared/state/user_state.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<PingState>(() => PingState());
  getIt.registerLazySingleton<ContainerState>(() => ContainerState());
  getIt.registerLazySingleton<ServiceState>(() => ServiceState());
  getIt.registerLazySingleton<MetricsState>(() => MetricsState());
  getIt.registerLazySingleton<UserState>(() => UserState());
}

