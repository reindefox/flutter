import 'dart:async';
import 'dart:math';
import '../../../core/models/ping_model.dart';

class PingDTO {
  final String id;
  final DateTime timestamp;
  final int? latencyMs;
  final String? endpoint;
  final String? api;
  final String? error;

  PingDTO({
    required this.id,
    required this.timestamp,
    this.latencyMs,
    this.endpoint,
    this.api,
    this.error,
  });

  PingModel toModel() {
    return PingModel(
      id: id,
      timestamp: timestamp,
      latencyMs: latencyMs,
      isComplete: latencyMs != null,
      endpoint: endpoint,
      api: api,
      error: error,
    );
  }
}

class PingLocalDataSource {
  final List<PingDTO> _pings = [];
  final _random = Random();
  
  final _pingsController = StreamController<List<PingModel>>.broadcast();

  Stream<List<PingModel>> get pingsStream => _pingsController.stream;

  List<PingModel> getPings() {
    return _pings.map((dto) => dto.toModel()).toList();
  }

  Future<PingModel> sendPing() async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final timestamp = DateTime.now();
    
    final dto = PingDTO(
      id: id,
      timestamp: timestamp,
      latencyMs: null,
    );
    _pings.add(dto);
    _notifyPingsChanged();
    
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _pings.indexWhere((p) => p.id == id);
    if (index != -1) {
      _pings[index] = PingDTO(
        id: id,
        timestamp: timestamp,
        latencyMs: _random.nextInt(100) + 1,
      );
      _notifyPingsChanged();
    }
    
    return _pings[index].toModel();
  }

  void removePing(String id) {
    _pings.removeWhere((p) => p.id == id);
    _notifyPingsChanged();
  }

  void clearPings() {
    _pings.clear();
    _notifyPingsChanged();
  }

  void _notifyPingsChanged() {
    _pingsController.add(getPings());
  }

  void dispose() {
    _pingsController.close();
  }
}
