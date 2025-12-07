import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/widgets/content_page.dart';
import '../../../core/models/metrics_model.dart';
import '../../../domain/usecases/metrics_usecases.dart';
import '../../../shared/di/service_locator.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  late final GetCurrentMetricsUseCase _getCurrentMetrics;
  late final StartMetricsMonitoringUseCase _startMonitoring;
  late final StopMetricsMonitoringUseCase _stopMonitoring;

  MetricsModel? _metrics;
  StreamSubscription? _metricsSub;

  @override
  void initState() {
    super.initState();
    _getCurrentMetrics = getIt<GetCurrentMetricsUseCase>();
    _startMonitoring = getIt<StartMetricsMonitoringUseCase>();
    _stopMonitoring = getIt<StopMetricsMonitoringUseCase>();

    _startMonitoring();
    _subscribeToChanges();
  }

  void _subscribeToChanges() {
    _metricsSub = _getCurrentMetrics.watch().listen((metrics) {
      setState(() => _metrics = metrics);
    });
  }

  @override
  void dispose() {
    _stopMonitoring();
    _metricsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Мониторинг метрик',
      color: Colors.purple,
      body: _metrics == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  _buildMetricTile(
                    'Загрузка процессора',
                    _metrics!.cpuUsage,
                    Colors.red,
                    _metrics!.isCpuCritical,
                  ),
                  _buildMetricTile(
                    'Использование памяти',
                    _metrics!.memoryUsage,
                    Colors.blue,
                    _metrics!.isMemoryCritical,
                  ),
                  _buildMetricTile(
                    'Использование диска',
                    _metrics!.diskUsage,
                    Colors.green,
                    _metrics!.isDiskCritical,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        _metrics!.isHealthy ? Icons.check_circle : Icons.warning,
                        color: _metrics!.isHealthy ? Colors.green : Colors.orange,
                        size: 32,
                      ),
                      title: Text(
                        _metrics!.isHealthy
                            ? 'Система работает нормально'
                            : 'Обнаружена высокая нагрузка',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricTile(String title, double value, Color color, bool isCritical) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isCritical)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.warning, color: Colors.orange, size: 18),
              ),
          ],
        ),
        subtitle: LinearProgressIndicator(
          value: value / 100,
          color: isCritical ? Colors.red : color,
          backgroundColor: Colors.grey[300],
        ),
        trailing: Text(
          '${value.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isCritical ? Colors.red : Colors.black87,
          ),
        ),
      ),
    );
  }
}
