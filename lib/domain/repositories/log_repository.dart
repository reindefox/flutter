import '../../core/models/log_entry_model.dart';

abstract class LogRepository {
  Future<List<LogEntryModel>> getAllLogs();

  Future<List<LogEntryModel>> getLogsByType(LogType type);

  Future<LogEntryModel> addLogEntry(LogEntryModel entry);

  Stream<List<LogEntryModel>> watchLogs();
}
