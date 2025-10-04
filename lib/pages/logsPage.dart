import 'package:flutter/material.dart';

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