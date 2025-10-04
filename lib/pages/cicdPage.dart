import 'package:flutter/material.dart';

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