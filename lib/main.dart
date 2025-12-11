import 'package:flutter/material.dart';
import 'package:project/app/routes.dart';
import 'package:project/shared/di/service_locator.dart';
import 'package:project/core/services/auth_service.dart';
import 'package:project/core/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setupServiceLocator();
  
  final settingsService = getIt<SettingsService>();
  await settingsService.init();
  
  final authService = getIt<AuthService>();
  await authService.tryRestoreSession();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthService _authService;
  late final SettingsService _settingsService;

  @override
  void initState() {
    super.initState();
    _authService = getIt<AuthService>();
    _settingsService = getIt<SettingsService>();
    _authService.addListener(_onAuthChanged);
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    appRouter.refresh();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Application',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _settingsService.themeMode,
      routerConfig: appRouter,
    );
  }
}
