import 'package:flutter/material.dart';

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