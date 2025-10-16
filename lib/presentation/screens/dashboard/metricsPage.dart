import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../base/contentPage.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  final Random _random = Random();
  late Timer _timer;

  double _cpuUsage = 0;
  double _memoryUsage = 0;
  double _diskUsage = 0;

  @override
  void initState() {
    super.initState();
    _updateMetrics();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _updateMetrics());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateMetrics() {
    setState(() {
      _cpuUsage = _random.nextDouble() * 100;
      _memoryUsage = _random.nextDouble() * 100;
      _diskUsage = _random.nextDouble() * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Мониторинг метрик',
      color: Colors.purple,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            _buildMetricTile('Загрузка процессора', _cpuUsage, Colors.red),
            _buildMetricTile('Использование памяти', _memoryUsage, Colors.blue),
            _buildMetricTile('Использование диска', _diskUsage, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, double value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: LinearProgressIndicator(
          value: value / 100,
          color: color,
          backgroundColor: Colors.grey[300],
        ),
        trailing: Text('${value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
