import 'package:project/core/models/api/api_models.dart';

abstract class JsonPlaceholderRepository {

  Future<List<ApiUser>> getUsers();

  Future<ApiUser> getUserById(int id);

  Future<List<ApiPost>> getPosts({int? limit});

  Future<List<ApiPost>> getPostsByUser(int userId);

  Future<List<ApiComment>> getCommentsByPost(int postId);

  Future<ApiPost> createPost({
    required int userId,
    required String title,
    required String body,
  });
}

abstract class GithubApiRepository {

  Future<GithubRepository> getRepository(String owner, String repo);

  Future<GithubSearchResult> searchRepositories({
    required String query,
    String? language,
    String sort = 'stars',
    String order = 'desc',
    int perPage = 10,
    int page = 1,
  });

  Future<List<GithubRepository>> getUserRepositories(String username);

  Future<GithubSearchResult> getTrendingRepositories({
    String? language,
    int perPage = 10,
  });
}
