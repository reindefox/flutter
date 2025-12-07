import 'dart:async';
import '../../../core/models/log_entry_model.dart';

class LogEntryDTO {
  final String id;
  final String user;
  final String action;
  final String target;
  final DateTime timestamp;
  final String type;

  LogEntryDTO({
    required this.id,
    required this.user,
    required this.action,
    required this.target,
    required this.timestamp,
    required this.type,
  });

  LogEntryModel toModel() {
    return LogEntryModel(
      id: id,
      user: user,
      action: action,
      target: target,
      timestamp: timestamp,
      type: _parseType(type),
    );
  }

  LogType _parseType(String type) {
    switch (type) {
      case 'containers':
        return LogType.containers;
      case 'services':
        return LogType.services;
      case 'pings':
        return LogType.pings;
      default:
        return LogType.system;
    }
  }

  factory LogEntryDTO.fromModel(LogEntryModel model) {
    return LogEntryDTO(
      id: model.id,
      user: model.user,
      action: model.action,
      target: model.target,
      timestamp: model.timestamp,
      type: model.type.name,
    );
  }
}

class LogLocalDataSource {
  final List<LogEntryDTO> _logs = [
    LogEntryDTO(
      id: '1',
      user: 'Лев',
      action: 'запустил',
      target: 'контейнер nginx',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: 'containers',
    ),
    LogEntryDTO(
      id: '2',
      user: 'Лев',
      action: 'остановил',
      target: 'контейнер redis',
      timestamp: DateTime.now().subtract(const Duration(minutes: 22)),
      type: 'containers',
    ),
    LogEntryDTO(
      id: '3',
      user: 'Лев',
      action: 'перезапустил',
      target: 'сервис API',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
      type: 'services',
    ),
    LogEntryDTO(
      id: '4',
      user: 'Лев',
      action: 'запустил',
      target: 'пинг сервера',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      type: 'pings',
    ),
  ];

  final _logsController = StreamController<List<LogEntryModel>>.broadcast();

  Stream<List<LogEntryModel>> get logsStream => _logsController.stream;

  List<LogEntryModel> getAllLogs() {
    return _logs.map((dto) => dto.toModel()).toList();
  }

  List<LogEntryModel> getLogsByType(LogType type) {
    return _logs
        .where((dto) => dto.type == type.name)
        .map((dto) => dto.toModel())
        .toList();
  }

  LogEntryModel addLogEntry(LogEntryModel entry) {
    final dto = LogEntryDTO.fromModel(entry);
    _logs.insert(0, dto);
    _notifyLogsChanged();
    return dto.toModel();
  }

  void _notifyLogsChanged() {
    _logsController.add(getAllLogs());
  }

  void dispose() {
    _logsController.close();
  }
}
