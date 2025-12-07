import '../../core/models/log_entry_model.dart';
import '../../domain/repositories/log_repository.dart';
import '../datasources/local/log_local_datasource.dart';

class LogRepositoryImpl implements LogRepository {
  final LogLocalDataSource _localDataSource;

  LogRepositoryImpl(this._localDataSource);

  @override
  Future<List<LogEntryModel>> getAllLogs() async {
    return _localDataSource.getAllLogs();
  }

  @override
  Future<List<LogEntryModel>> getLogsByType(LogType type) async {
    return _localDataSource.getLogsByType(type);
  }

  @override
  Future<LogEntryModel> addLogEntry(LogEntryModel entry) async {
    return _localDataSource.addLogEntry(entry);
  }

  @override
  Stream<List<LogEntryModel>> watchLogs() {
    return _localDataSource.logsStream;
  }
}
