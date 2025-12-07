class ContainerModel {
  final String id;
  final String name;
  final bool isRunning;
  final String log;
  final DateTime? startedAt;

  const ContainerModel({
    required this.id,
    required this.name,
    required this.isRunning,
    required this.log,
    this.startedAt,
  });

  ContainerModel copyWith({
    String? id,
    String? name,
    bool? isRunning,
    String? log,
    DateTime? startedAt,
  }) {
    return ContainerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isRunning: isRunning ?? this.isRunning,
      log: log ?? this.log,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  bool get isActive => isRunning;

  String get statusText => isRunning ? 'Запущен' : 'Остановлен';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContainerModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isRunning == other.isRunning;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isRunning.hashCode;

  @override
  String toString() => 'ContainerModel(id: $id, name: $name, isRunning: $isRunning)';
}
