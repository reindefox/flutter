import 'package:flutter/material.dart';

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