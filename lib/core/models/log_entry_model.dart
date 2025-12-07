enum LogType {
  containers('Контейнеры'),
  services('Сервисы'),
  pings('Пинги'),
  system('Система');

  const LogType(this.displayName);
  final String displayName;
}


class LogEntryModel {
  final String id;
  final String user;
  final String action;
  final String target;
  final DateTime timestamp;
  final LogType type;

  const LogEntryModel({
    required this.id,
    required this.user,
    required this.action,
    required this.target,
    required this.timestamp,
    required this.type,
  });

  LogEntryModel copyWith({
    String? id,
    String? user,
    String? action,
    String? target,
    DateTime? timestamp,
    LogType? type,
  }) {
    return LogEntryModel(
      id: id ?? this.id,
      user: user ?? this.user,
      action: action ?? this.action,
      target: target ?? this.target,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
    );
  }

  String get fullActionText => '$user $action $target';

  String get formattedTimestamp {
    final d = timestamp;
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntryModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LogEntryModel(id: $id, action: $fullActionText)';
}
