import 'dart:async';
import 'dart:math';
import 'package:mobx/mobx.dart';

part 'metrics_state.g.dart';

class MetricsState = _MetricsState with _$MetricsState;

abstract class _MetricsState with Store {
  final Random _random = Random();
  Timer? _timer;

  @observable
  double cpuUsage = 0;

  @observable
  double memoryUsage = 0;

  @observable
  double diskUsage = 0;

  @action
  void startMonitoring() {
    _updateMetrics();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _updateMetrics());
  }

  @action
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  @action
  void _updateMetrics() {
    cpuUsage = _random.nextDouble() * 100;
    memoryUsage = _random.nextDouble() * 100;
    diskUsage = _random.nextDouble() * 100;
  }

  void dispose() {
    stopMonitoring();
  }
}

