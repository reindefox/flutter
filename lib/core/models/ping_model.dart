class PingModel {
  final String id;
  final DateTime timestamp;
  final int? latencyMs;
  final bool isComplete;

  const PingModel({
    required this.id,
    required this.timestamp,
    this.latencyMs,
    this.isComplete = false,
  });

  PingModel copyWith({
    String? id,
    DateTime? timestamp,
    int? latencyMs,
    bool? isComplete,
  }) {
    return PingModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      latencyMs: latencyMs ?? this.latencyMs,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String get latencyText => latencyMs != null ? '${latencyMs}ms' : '...';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PingModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PingModel(id: $id, latency: $latencyMs)';
}
