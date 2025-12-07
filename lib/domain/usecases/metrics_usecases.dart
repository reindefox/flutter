import '../../core/models/metrics_model.dart';
import '../repositories/metrics_repository.dart';

class GetCurrentMetricsUseCase {
  final MetricsRepository _repository;

  GetCurrentMetricsUseCase(this._repository);

  Future<MetricsModel> call() => _repository.getCurrentMetrics();
  
  Stream<MetricsModel> watch() => _repository.watchMetrics();
}

class StartMetricsMonitoringUseCase {
  final MetricsRepository _repository;

  StartMetricsMonitoringUseCase(this._repository);

  void call() => _repository.startMonitoring();
}

class StopMetricsMonitoringUseCase {
  final MetricsRepository _repository;

  StopMetricsMonitoringUseCase(this._repository);

  void call() => _repository.stopMonitoring();
}
