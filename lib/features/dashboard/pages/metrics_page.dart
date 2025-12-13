import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/widgets/content_page.dart';
import '../../../core/models/metrics_model.dart';
import '../../../domain/repositories/api_repository.dart' show InfrastructureRepository;
import '../../../data/datasources/remote/infrastructure_datasource.dart'
    show InfrastructureStatus, InfrastructureService;
import '../../../domain/usecases/metrics_usecases.dart';
import '../../../domain/usecases/api_usecases.dart';
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
  late final GetServicesStatusUseCase _getServicesStatus;
  late final GetMainServerStatusUseCase _getMainServerStatus;

  MetricsModel? _metrics;
  StreamSubscription? _metricsSub;

  List<InfrastructureService>? _services;
  InfrastructureStatus? _mainServer;
  bool _isLoadingServerData = false;
  String? _serverError;

  @override
  void initState() {
    super.initState();
    _getCurrentMetrics = getIt<GetCurrentMetricsUseCase>();
    _startMonitoring = getIt<StartMetricsMonitoringUseCase>();
    _stopMonitoring = getIt<StopMetricsMonitoringUseCase>();
    _getServicesStatus = getIt<GetServicesStatusUseCase>();
    _getMainServerStatus = getIt<GetMainServerStatusUseCase>();

    _startMonitoring();
    _subscribeToChanges();
    _loadServerData();
  }

  void _subscribeToChanges() {
    _metricsSub = _getCurrentMetrics.watch().listen((metrics) {
      setState(() => _metrics = metrics);
    });
  }

  Future<void> _loadServerData() async {
    setState(() {
      _isLoadingServerData = true;
      _serverError = null;
    });
    
    try {
      final mainServer = await _getMainServerStatus();
      final services = await _getServicesStatus();
      
      setState(() {
        _mainServer = mainServer;
        _services = services;
        _isLoadingServerData = false;
      });
    } catch (e) {
      setState(() {
        _serverError = e.toString();
        _isLoadingServerData = false;
      });
    }
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
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 8),
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
                  
                  const SizedBox(height: 24),

                  _buildSectionHeader('Статистика серверов', Icons.dns),
                  
                  if (_isLoadingServerData)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  
                  if (_serverError != null)
                    _buildErrorCard(_serverError!),
                  
                  if (_mainServer != null)
                    _buildMainServerCard(_mainServer!),
                  
                  if (_services != null && _services!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildServicesStatsSection(_services!),
                  ],

                  if (!_isLoadingServerData)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: TextButton.icon(
                          onPressed: _loadServerData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Обновить статистику'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Данные с сервера',
              style: TextStyle(fontSize: 10, color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainServerCard(InfrastructureStatus server) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.computer, color: Colors.purple),
            ),
            title: Text(
              server.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Основной сервер инфраструктуры',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.people, '${server.connections}', 'Подключений', Colors.amber),
                _buildStatItem(Icons.sync, '${server.synchronizations}', 'Синхронизаций', Colors.blue),
                _buildStatItem(Icons.warning_amber, '${server.incidents}', 'Инцидентов', Colors.red),
                _buildStatItem(Icons.memory, server.platform, 'Платформа', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildServicesStatsSection(List<InfrastructureService> services) {
    final activeCount = services.where((s) => s.isActive).length;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.cloud_queue, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Связанные сервисы',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$activeCount активных',
                    style: TextStyle(fontSize: 11, color: Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...services.map((service) => ListTile(
            dense: true,
            leading: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.cloud_done, size: 16, color: Colors.blue),
            ),
            title: Text(
              service.name,
              style: const TextStyle(fontSize: 13),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: service.isActive ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(child: Text(error)),
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
