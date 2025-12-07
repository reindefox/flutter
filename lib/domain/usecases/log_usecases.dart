import '../../core/models/log_entry_model.dart';
import '../repositories/log_repository.dart';

class GetAllLogsUseCase {
  final LogRepository _repository;

  GetAllLogsUseCase(this._repository);

  Future<List<LogEntryModel>> call() => _repository.getAllLogs();
  
  Stream<List<LogEntryModel>> watch() => _repository.watchLogs();
}

class GetLogsByTypeUseCase {
  final LogRepository _repository;

  GetLogsByTypeUseCase(this._repository);

  Future<List<LogEntryModel>> call(LogType type) => _repository.getLogsByType(type);
}

class AddLogEntryUseCase {
  final LogRepository _repository;

  AddLogEntryUseCase(this._repository);

  Future<LogEntryModel> call(LogEntryModel entry) => _repository.addLogEntry(entry);
}
