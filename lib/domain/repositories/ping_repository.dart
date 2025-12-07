import '../../core/models/ping_model.dart';

abstract class PingRepository {
  Future<List<PingModel>> getPingHistory();

  Future<PingModel> sendPing();

  Future<void> removePing(String id);

  Future<void> clearHistory();

  Stream<List<PingModel>> watchPings();
}
