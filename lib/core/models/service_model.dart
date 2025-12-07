enum ServiceStatus {
  running('Запущен'),
  stopped('Остановлен'),
  error('Ошибка');

  const ServiceStatus(this.displayName);
  final String displayName;
}

class ServiceModel {
  final String id;
  final String name;
  final ServiceStatus status;
  final String log;
  final DateTime? lastUpdated;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.status,
    required this.log,
    this.lastUpdated,
  });

  ServiceModel copyWith({
    String? id,
    String? name,
    ServiceStatus? status,
    String? log,
    DateTime? lastUpdated,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      log: log ?? this.log,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get isRunning => status == ServiceStatus.running;

  bool get hasError => status == ServiceStatus.error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'ServiceModel(id: $id, name: $name, status: $status)';
}
