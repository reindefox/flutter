import 'package:project/core/models/api/api_models.dart';
import 'package:project/data/datasources/remote/json_placeholder_datasource.dart';
import 'package:project/domain/repositories/api_repository.dart';

class JsonPlaceholderRepositoryImpl implements JsonPlaceholderRepository {
  final JsonPlaceholderDataSource _dataSource;

  JsonPlaceholderRepositoryImpl(this._dataSource);

  @override
  Future<List<ApiUser>> getUsers() {
    return _dataSource.getUsers();
  }

  @override
  Future<ApiUser> getUserById(int id) {
    return _dataSource.getUserById(id);
  }

  @override
  Future<List<ApiPost>> getPosts({int? limit}) {
    return _dataSource.getPosts(limit: limit);
  }

  @override
  Future<List<ApiPost>> getPostsByUser(int userId) {
    return _dataSource.getPostsByUser(userId);
  }

  @override
  Future<List<ApiComment>> getCommentsByPost(int postId) {
    return _dataSource.getCommentsByPost(postId);
  }

  @override
  Future<ApiPost> createPost({
    required int userId,
    required String title,
    required String body,
  }) {
    return _dataSource.createPost(
      userId: userId,
      title: title,
      body: body,
    );
  }
}
