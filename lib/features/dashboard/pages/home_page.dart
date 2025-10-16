import 'package:flutter/material.dart';
import './docker_container_manager_page.dart';
import './service_manager_page.dart';
import './ping_tracker_page.dart';
import './metrics_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: const DashboardGrid(),
    );
  }
}

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          if (constraints.maxWidth > 900) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 3;
          }
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildDashboardCard(
                context,
                'Пинги',
                Icons.network_ping,
                Colors.green,
                const WidgetColumnPage(),
              ),
              _buildDashboardCard(
                context,
                'Контейнеры',
                Icons.dns,
                Colors.blue,
                const ListViewPage(),
              ),
              _buildDashboardCard(
                context,
                'Сервисы',
                Icons.settings,
                Colors.orange,
                const ListViewSeparatedPage(),
              ),
              _buildDashboardCard(
                context,
                'Мониторинг метрик',
                Icons.monitor_heart,
                Colors.purple,
                const MetricsPage(),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildDashboardCard(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
  Widget destination,
) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
