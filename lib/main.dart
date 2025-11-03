import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/app/routes.dart';
import 'package:project/shared/state/user_state.dart';
import 'package:project/shared/state/ping_state.dart';
import 'package:project/shared/state/container_state.dart';
import 'package:project/shared/state/service_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => PingState()),
        ChangeNotifierProvider(create: (_) => ContainerState()),
        ChangeNotifierProvider(create: (_) => ServiceState()),
      ],
      child: MaterialApp.router(
        title: 'Application',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
