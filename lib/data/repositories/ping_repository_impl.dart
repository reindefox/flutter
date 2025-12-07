import '../../core/models/ping_model.dart';
import '../../domain/repositories/ping_repository.dart';
import '../datasources/local/ping_local_datasource.dart';

class PingRepositoryImpl implements PingRepository {
  final PingLocalDataSource _localDataSource;

  PingRepositoryImpl(this._localDataSource);

  @override
  Future<List<PingModel>> getPingHistory() async {
    return _localDataSource.getPings();
  }

  @override
  Future<PingModel> sendPing() async {
    return _localDataSource.sendPing();
  }

  @override
  Future<void> removePing(String id) async {
    _localDataSource.removePing(id);
  }

  @override
  Future<void> clearHistory() async {
    _localDataSource.clearPings();
  }

  @override
  Stream<List<PingModel>> watchPings() {
    return _localDataSource.pingsStream;
  }
}
