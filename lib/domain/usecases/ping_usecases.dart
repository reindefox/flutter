import '../../core/models/ping_model.dart';
import '../repositories/ping_repository.dart';

class GetPingHistoryUseCase {
  final PingRepository _repository;

  GetPingHistoryUseCase(this._repository);

  Future<List<PingModel>> call() => _repository.getPingHistory();
  
  Stream<List<PingModel>> watch() => _repository.watchPings();
}

class SendPingUseCase {
  final PingRepository _repository;

  SendPingUseCase(this._repository);

  Future<PingModel> call() => _repository.sendPing();
}

class RemovePingUseCase {
  final PingRepository _repository;

  RemovePingUseCase(this._repository);

  Future<void> call(String id) => _repository.removePing(id);
}

class ClearPingHistoryUseCase {
  final PingRepository _repository;

  ClearPingHistoryUseCase(this._repository);

  Future<void> call() => _repository.clearHistory();
}
