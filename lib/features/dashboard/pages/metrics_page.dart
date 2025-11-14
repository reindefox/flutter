import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../shared/widgets/content_page.dart';
import 'package:project/shared/state/metrics_state.dart';
import 'package:project/shared/di/service_locator.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  late final MetricsState _metricsState;

  @override
  void initState() {
    super.initState();
    _metricsState = getIt<MetricsState>();
    _metricsState.startMonitoring();
  }

  @override
  void dispose() {
    _metricsState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Мониторинг метрик',
      color: Colors.purple,
      body: Observer(
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              _buildMetricTile('Загрузка процессора', _metricsState.cpuUsage, Colors.red),
              _buildMetricTile('Использование памяти', _metricsState.memoryUsage, Colors.blue),
              _buildMetricTile('Использование диска', _metricsState.diskUsage, Colors.green),
            ],
          ),
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
