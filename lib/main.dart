import 'package:flutter/material.dart';
import 'package:project/app/routes.dart';
import 'package:project/shared/state/user_state.dart';
import 'package:project/shared/di/service_locator.dart';

void main() {
  setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UserStateProvider(
      userState: UserState(),
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


