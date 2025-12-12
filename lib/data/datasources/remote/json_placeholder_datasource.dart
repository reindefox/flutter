import 'package:dio/dio.dart';
import 'package:project/core/models/api/api_models.dart';
import 'package:project/core/services/dio_client.dart';







class JsonPlaceholderDataSource {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  final DioClient _dioClient;

  JsonPlaceholderDataSource(this._dioClient);


  Future<List<ApiUser>> getUsers() async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/users',
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => ApiUser.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<ApiUser> getUserById(int id) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_baseUrl/users/$id',
      );
      
      if (response.data == null) {
        throw Exception('Пользователь не найден');
      }
      
      return ApiUser.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<List<ApiPost>> getPosts({int? limit}) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/posts',
        queryParameters: limit != null ? {'_limit': limit} : null,
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => ApiPost.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<List<ApiPost>> getPostsByUser(int userId) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/posts',
        queryParameters: {'userId': userId},
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => ApiPost.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<List<ApiComment>> getCommentsByPost(int postId) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/comments',
        queryParameters: {'postId': postId},
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => ApiComment.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<ApiPost> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '$_baseUrl/posts',
        data: {
          'userId': userId,
          'title': title,
          'body': body,
        },
      );
      
      if (response.data == null) {
        throw Exception('Ошибка создания поста');
      }
      
      return ApiPost.fromJson(response.data!);
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
          return Exception('Ресурс не найден');
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
