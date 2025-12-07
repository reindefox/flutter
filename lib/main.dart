import 'package:flutter/material.dart';
import 'package:project/app/routes.dart';
import 'package:project/shared/di/service_locator.dart';
import 'package:project/core/services/auth_service.dart';

void main() {
  setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = getIt<AuthService>();
    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    // Обновляем роутер при изменении состояния аутентификации
    appRouter.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Application',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: appRouter,
    );
  }
}


