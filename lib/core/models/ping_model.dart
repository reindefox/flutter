class PingModel {
  final String id;
  final DateTime timestamp;
  final int? latencyMs;
  final bool isComplete;
  final String? endpoint;
  final String? api;
  final String? error;

  const PingModel({
    required this.id,
    required this.timestamp,
    this.latencyMs,
    this.isComplete = false,
    this.endpoint,
    this.api,
    this.error,
  });

  PingModel copyWith({
    String? id,
    DateTime? timestamp,
    int? latencyMs,
    bool? isComplete,
    String? endpoint,
    String? api,
    String? error,
  }) {
    return PingModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      latencyMs: latencyMs ?? this.latencyMs,
      isComplete: isComplete ?? this.isComplete,
      endpoint: endpoint ?? this.endpoint,
      api: api ?? this.api,
      error: error ?? this.error,
    );
  }

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String get latencyText {
    if (error != null) return error!;
    return latencyMs != null ? '${latencyMs}ms' : '...';
  }

  bool get hasError => error != null;

  String get displayName => endpoint ?? 'Ping';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PingModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PingModel(id: $id, endpoint: $endpoint, latency: $latencyMs)';
}
