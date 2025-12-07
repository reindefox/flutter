import '../../core/models/metrics_model.dart';
import '../../domain/repositories/metrics_repository.dart';
import '../datasources/local/metrics_local_datasource.dart';

class MetricsRepositoryImpl implements MetricsRepository {
  final MetricsLocalDataSource _localDataSource;

  MetricsRepositoryImpl(this._localDataSource);

  @override
  Future<MetricsModel> getCurrentMetrics() async {
    return _localDataSource.getCurrentMetrics();
  }

  @override
  void startMonitoring() {
    _localDataSource.startMonitoring();
  }

  @override
  void stopMonitoring() {
    _localDataSource.stopMonitoring();
  }

  @override
  Stream<MetricsModel> watchMetrics() {
    return _localDataSource.metricsStream;
  }
}
