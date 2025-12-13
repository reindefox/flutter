import 'package:dio/dio.dart';
import 'package:project/core/services/dio_client.dart';

class InfrastructureStatus {
  final String name;
  final int connections;
  final int synchronizations;
  final int incidents;
  final String platform;

  const InfrastructureStatus({
    required this.name,
    required this.connections,
    required this.synchronizations,
    required this.incidents,
    required this.platform,
  });

  factory InfrastructureStatus.fromJson(Map<String, dynamic> json) {
    return InfrastructureStatus(
      name: json['name'] as String? ?? 'Сервер',
      connections: json['connections'] as int? ?? 0,
      synchronizations: json['synchronizations'] as int? ?? 0,
      incidents: json['incidents'] as int? ?? 0,
      platform: json['platform'] as String? ?? 'N/A',
    );
  }
}

class InfrastructureService {
  final String name;
  final int requestsPerSecond;
  final bool isActive;

  const InfrastructureService({
    required this.name,
    required this.requestsPerSecond,
    required this.isActive,
  });

  factory InfrastructureService.fromJson(Map<String, dynamic> json) {
    return InfrastructureService(
      name: json['name'] as String? ?? 'Сервис',
      requestsPerSecond: json['requestsPerSecond'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class InfrastructureDataSource {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  final DioClient _dioClient;

  InfrastructureDataSource(this._dioClient);

  Future<InfrastructureStatus> getMainServerStatus() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_baseUrl/posts/1',
      );
      
      if (response.data == null) {
        throw Exception('Данные сервера не найдены');
      }
      
      final data = response.data!;
      return InfrastructureStatus(
        name: 'Главный сервер',
        connections: data['id'] as int? ?? 100,
        synchronizations: (data['id'] as int? ?? 1) * 10,
        incidents: ((data['id'] as int? ?? 1) % 3),
        platform: 'Node.js',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<InfrastructureService>> getServicesStatus() async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/posts',
        queryParameters: {'_limit': 5},
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value as Map<String, dynamic>;
        return InfrastructureService(
          name: 'Сервис ${data['id'] ?? index + 1}',
          requestsPerSecond: (data['id'] as int? ?? index + 1) * 10,
          isActive: true,
        );
      }).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Время ожидания истекло. Проверьте подключение к интернету.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Данные не найдены');
        } else if (statusCode == 500) {
          return Exception('Ошибка сервера');
        }
        return Exception('Ошибка запроса: $statusCode');
      case DioExceptionType.connectionError:
        return Exception('Нет подключения к интернету');
      default:
        return Exception('Произошла ошибка: ${e.message}');
    }
  }
}
