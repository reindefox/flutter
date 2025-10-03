import 'package:flutter/material.dart';
import 'main.dart';

class ServerInfoPage extends StatelessWidget {
  const ServerInfoPage({super.key});

  final List<String> serverInfo = const [
    'CPU: 35%',
    'RAM: 2.1 GB / 4 GB',
    'Disk: 120 GB / 256 GB',
    'Uptime: 3 days 4 hours 12 minutes',
    'Server status: 🟢 ONLINE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Информация о сервере'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Icon(Icons.storage, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: serverInfo
                    .map(
                      (line) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            line,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrometheusPage extends StatelessWidget {
  const PrometheusPage({super.key});

  final List<String> prometheusMetrics = const [
    'HTTP Requests: 1,234',
    'Errors: 12',
    'Active Users: 57',
    'Average Response Time: 220 ms',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Метрики Prometheus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Icon(Icons.show_chart, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: prometheusMetrics
                    .map(
                      (line) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            line,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  final List<String> alerts = const [
    '[!] CPU Usage High: 92%',
    '[!] Disk Space Low: 10 GB left',
    '[✔] All services running',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Alerting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Icon(
              Icons.notification_important,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: alerts
                    .map(
                      (line) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            line,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  final List<String> logs = const [
    '[2025-10-03 12:01] INFO: Server started',
    '[2025-10-03 12:05] WARN: High memory usage',
    '[2025-10-03 12:10] ERROR: Failed to connect to DB',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Логи сервера'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Icon(Icons.list_alt, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: logs
                    .map(
                      (line) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            line,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CiCdPage extends StatelessWidget {
  const CiCdPage({super.key});

  final List<String> cicdStatus = const [
    'Build #124: ✅ Success',
    'Build #125: ❌ Failed',
    'Build #126: ✅ Success',
    'Last deploy: 2025-10-02 21:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('CI/CD Статус'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Icon(Icons.build_circle, size: 80, color: Colors.purple),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: cicdStatus
                    .map(
                      (line) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            line,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
