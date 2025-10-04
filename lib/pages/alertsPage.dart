import 'package:flutter/material.dart';

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