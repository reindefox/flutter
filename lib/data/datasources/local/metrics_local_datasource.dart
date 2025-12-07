import 'dart:async';
import 'dart:math';
import '../../../core/models/metrics_model.dart';

class MetricsDTO {
  final double cpu;
  final double memory;
  final double disk;
  final DateTime timestamp;

  MetricsDTO({
    required this.cpu,
    required this.memory,
    required this.disk,
    required this.timestamp,
  });

  MetricsModel toModel() {
    return MetricsModel(
      cpuUsage: cpu,
      memoryUsage: memory,
      diskUsage: disk,
      timestamp: timestamp,
    );
  }
}

class MetricsLocalDataSource {
  final _random = Random();
  Timer? _timer;
  
  final _metricsController = StreamController<MetricsModel>.broadcast();

  Stream<MetricsModel> get metricsStream => _metricsController.stream;

  MetricsModel getCurrentMetrics() {
    return _generateMetrics();
  }

  void startMonitoring() {
    _metricsController.add(_generateMetrics());
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _metricsController.add(_generateMetrics());
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  MetricsModel _generateMetrics() {
    final dto = MetricsDTO(
      cpu: _random.nextDouble() * 100,
      memory: _random.nextDouble() * 100,
      disk: _random.nextDouble() * 100,
      timestamp: DateTime.now(),
    );
    return dto.toModel();
  }

  void dispose() {
    stopMonitoring();
    _metricsController.close();
  }
}
