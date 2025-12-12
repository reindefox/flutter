import '../../core/models/ping_model.dart';
import '../../domain/repositories/ping_repository.dart';
import '../datasources/remote/ping_remote_datasource.dart';


class PingRepositoryImpl implements PingRepository {
  final PingRemoteDataSource _remoteDataSource;

  PingRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PingModel>> getPingHistory() async {
    return _remoteDataSource.getPings();
  }

  @override
  Future<PingModel> sendPing() async {
    return _remoteDataSource.sendPing();
  }

  @override
  Future<void> removePing(String id) async {
    _remoteDataSource.removePing(id);
  }

  @override
  Future<void> clearHistory() async {
    _remoteDataSource.clearPings();
  }

  @override
  Stream<List<PingModel>> watchPings() {
    return _remoteDataSource.pingsStream;
  }
}
