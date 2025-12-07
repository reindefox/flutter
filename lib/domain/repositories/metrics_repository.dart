import '../../core/models/metrics_model.dart';

abstract class MetricsRepository {
  Future<MetricsModel> getCurrentMetrics();

  void startMonitoring();

  void stopMonitoring();

  Stream<MetricsModel> watchMetrics();
}
