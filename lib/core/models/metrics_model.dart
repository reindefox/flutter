class MetricsModel {
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final DateTime timestamp;

  const MetricsModel({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.timestamp,
  });

  MetricsModel copyWith({
    double? cpuUsage,
    double? memoryUsage,
    double? diskUsage,
    DateTime? timestamp,
  }) {
    return MetricsModel(
      cpuUsage: cpuUsage ?? this.cpuUsage,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      diskUsage: diskUsage ?? this.diskUsage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  bool get isCpuCritical => cpuUsage > 90;

  bool get isMemoryCritical => memoryUsage > 90;

  bool get isDiskCritical => diskUsage > 90;

  bool get isHealthy => !isCpuCritical && !isMemoryCritical && !isDiskCritical;

  @override
  String toString() =>
      'MetricsModel(cpu: ${cpuUsage.toStringAsFixed(1)}%, mem: ${memoryUsage.toStringAsFixed(1)}%, disk: ${diskUsage.toStringAsFixed(1)}%)';
}
