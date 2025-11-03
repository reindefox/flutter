import 'package:go_router/go_router.dart';
import 'package:project/app/root_shell.dart';
import 'package:project/features/dashboard/pages/home_page.dart';
import 'package:project/features/dashboard/pages/ping_tracker_page.dart';
import 'package:project/features/dashboard/pages/docker_container_manager_page.dart';
import 'package:project/features/dashboard/pages/service_manager_page.dart';
import 'package:project/features/dashboard/pages/metrics_page.dart';
import 'package:project/features/logs/pages/logs_page.dart';
import 'package:project/features/profile/pages/user_profile_page.dart';
import 'package:project/features/users/pages/user_accounts_page.dart';
import 'package:project/features/dashboard/pages/setup_wizard_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => RootShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/logs',
          name: 'logs',
          builder: (context, state) => const LogsPage(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const UserProfilePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/ping',
      name: 'ping',
      builder: (context, state) => const WidgetColumnPage(),
    ),
    GoRoute(
      path: '/containers',
      name: 'containers',
      builder: (context, state) => const ListViewPage(),
    ),
    GoRoute(
      path: '/services',
      name: 'services',
      builder: (context, state) => const ListViewSeparatedPage(),
    ),
    GoRoute(
      path: '/metrics',
      name: 'metrics',
      builder: (context, state) => const MetricsPage(),
    ),
    GoRoute(
      path: '/accounts',
      name: 'accounts',
      builder: (context, state) => const UserAccountsPage(),
    ),
    GoRoute(
      path: '/update-wizard',
      name: 'updateWizard',
      builder: (context, state) => const UpdateWizardPage(),
    ),
    GoRoute(
      path: '/update-wizard/step2',
      name: 'updateWizardStep2',
      builder: (context, state) => const WizardStep2Page(),
    ),
    GoRoute(
      path: '/update-wizard/step3',
      name: 'updateWizardStep3',
      builder: (context, state) => const WizardStep3Page(),
    ),
  ],
);

