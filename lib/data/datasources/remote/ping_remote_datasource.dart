import 'dart:async';
import 'package:dio/dio.dart';
import 'package:project/core/models/ping_model.dart';
import 'package:project/core/services/dio_client.dart';

class PingEndpoint {
  final String name;
  final String url;
  final String serverType;

  const PingEndpoint({
    required this.name,
    required this.url,
    required this.serverType,
  });
}



class PingRemoteDataSource {
  final DioClient _dioClient;
  
  final List<_PingEntry> _pingHistory = [];
  final _pingsController = StreamController<List<PingModel>>.broadcast();

  static const List<PingEndpoint> availableEndpoints = [
    PingEndpoint(
      name: 'Сервер пользователей',
      url: 'https://jsonplaceholder.typicode.com/users/1',
      serverType: 'JSONPlaceholder',
    ),
    PingEndpoint(
      name: 'Сервер контента',
      url: 'https://jsonplaceholder.typicode.com/posts/1',
      serverType: 'JSONPlaceholder',
    ),
    PingEndpoint(
      name: 'Внешний сервис',
      url: 'https://api.github.com',
      serverType: 'GitHub',
    ),
    PingEndpoint(
      name: 'Сервер репозиториев',
      url: 'https://api.github.com/repos/flutter/flutter',
      serverType: 'GitHub',
    ),
  ];

  int _currentEndpointIndex = 0;

  PingRemoteDataSource(this._dioClient);

  Stream<List<PingModel>> get pingsStream => _pingsController.stream;

  List<PingModel> getPings() {
    return _pingHistory.map((e) => e.toModel()).toList();
  }

  Future<PingModel> sendPing() async {
    final endpoint = availableEndpoints[_currentEndpointIndex];
    _currentEndpointIndex = (_currentEndpointIndex + 1) % availableEndpoints.length;

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final timestamp = DateTime.now();

    final entry = _PingEntry(
      id: id,
      timestamp: timestamp,
      endpoint: endpoint.name,
      api: endpoint.serverType,
      latencyMs: null,
      isComplete: false,
      error: null,
    );
    _pingHistory.insert(0, entry);
    _notifyChanged();

    final stopwatch = Stopwatch()..start();
    
    try {

      await _dioClient.get<dynamic>(endpoint.url);
      stopwatch.stop();
      
      final latency = stopwatch.elapsedMilliseconds;

      final index = _pingHistory.indexWhere((p) => p.id == id);
      if (index != -1) {
        _pingHistory[index] = _PingEntry(
          id: id,
          timestamp: timestamp,
          endpoint: endpoint.name,
          api: endpoint.serverType,
          latencyMs: latency,
          isComplete: true,
          error: null,
        );
        _notifyChanged();
      }
      
      return _pingHistory[index].toModel();
    } on DioException catch (e) {
      stopwatch.stop();
      
      final index = _pingHistory.indexWhere((p) => p.id == id);
      if (index != -1) {
        _pingHistory[index] = _PingEntry(
          id: id,
          timestamp: timestamp,
          endpoint: endpoint.name,
          api: endpoint.serverType,
          latencyMs: stopwatch.elapsedMilliseconds,
          isComplete: true,
          error: _parseError(e),
        );
        _notifyChanged();
      }
      
      return _pingHistory[index].toModel();
    }
  }

  void removePing(String id) {
    _pingHistory.removeWhere((p) => p.id == id);
    _notifyChanged();
  }

  void clearPings() {
    _pingHistory.clear();
    _notifyChanged();
  }

  void _notifyChanged() {
    _pingsController.add(getPings());
  }

  String _parseError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Timeout';
      case DioExceptionType.connectionError:
        return 'No connection';
      case DioExceptionType.badResponse:
        return 'Error ${e.response?.statusCode}';
      default:
        return 'Error';
    }
  }

  void dispose() {
    _pingsController.close();
  }
}

class _PingEntry {
  final String id;
  final DateTime timestamp;
  final String endpoint;
  final String api;
  final int? latencyMs;
  final bool isComplete;
  final String? error;

  _PingEntry({
    required this.id,
    required this.timestamp,
    required this.endpoint,
    required this.api,
    this.latencyMs,
    required this.isComplete,
    this.error,
  });

  PingModel toModel() {
    return PingModel(
      id: id,
      timestamp: timestamp,
      latencyMs: latencyMs,
      isComplete: isComplete,
      endpoint: endpoint,
      api: api,
      error: error,
    );
  }
}
