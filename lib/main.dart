import 'package:flutter/material.dart';
import 'package:project/presentation/screens/base/rootShell.dart';
import 'package:project/state/user_state.dart';
import 'package:project/state/ping_state.dart';
import 'package:project/state/container_state.dart';
import 'package:project/state/service_state.dart';
import 'package:project/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    return UserStateProvider(
      notifier: UserState(),
      child: PingStateProvider(
        notifier: PingState(),
        child: ContainerStateProvider(
          notifier: ContainerState(),
          child: ServiceStateProvider(
            notifier: ServiceState(),
            child: MaterialApp(
              title: 'Application',
              theme: ThemeData(
                useMaterial3: true,
                scaffoldBackgroundColor: Colors.white,
                // colorScheme: ColorScheme.fromSeed(
                //   seedColor: Colors.white
                // )
              ),
              home: const RootShell(),
            ),
          ),
        ),
      ),
    );
  }
}
