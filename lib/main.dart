import 'package:flutter/material.dart';
import 'package:project/pages/alertsPage.dart';
import 'package:project/pages/cicdPage.dart';
import 'package:project/pages/logsPage.dart';
import 'package:project/pages/prometheusPage.dart';
import 'package:project/pages/serverInfoPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevOps',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Выберите страницу',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              buildNavigationButton(
                context,
                'Информация о сервере',
                const ServerInfoPage(),
              ),
              buildNavigationButton(
                context,
                'Метрики Prometheus',
                const PrometheusPage(),
              ),
              buildNavigationButton(context, 'Alerting', const AlertsPage()),
              buildNavigationButton(context, 'Логи сервера', const LogsPage()),
              buildNavigationButton(context, 'CI/CD Статус', const CiCdPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationButton(
    BuildContext context,
    String text,
    Widget destination,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(250, 50)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
