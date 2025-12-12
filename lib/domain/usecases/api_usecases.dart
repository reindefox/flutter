import 'package:project/core/models/api/api_models.dart';
import 'package:project/domain/repositories/api_repository.dart';




class GetApiUsersUseCase {
  final JsonPlaceholderRepository _repository;

  GetApiUsersUseCase(this._repository);

  Future<List<ApiUser>> call() {
    return _repository.getUsers();
  }
}

class GetApiUserByIdUseCase {
  final JsonPlaceholderRepository _repository;

  GetApiUserByIdUseCase(this._repository);

  Future<ApiUser> call(int id) {
    return _repository.getUserById(id);
  }
}

class GetApiPostsUseCase {
  final JsonPlaceholderRepository _repository;

  GetApiPostsUseCase(this._repository);

  Future<List<ApiPost>> call({int? limit}) {
    return _repository.getPosts(limit: limit);
  }
}

class GetApiPostsByUserUseCase {
  final JsonPlaceholderRepository _repository;

  GetApiPostsByUserUseCase(this._repository);

  Future<List<ApiPost>> call(int userId) {
    return _repository.getPostsByUser(userId);
  }
}

class GetApiCommentsByPostUseCase {
  final JsonPlaceholderRepository _repository;

  GetApiCommentsByPostUseCase(this._repository);

  Future<List<ApiComment>> call(int postId) {
    return _repository.getCommentsByPost(postId);
  }
}

class CreateApiPostUseCase {
  final JsonPlaceholderRepository _repository;

  CreateApiPostUseCase(this._repository);

  Future<ApiPost> call({
    required int userId,
    required String title,
    required String body,
  }) {
    return _repository.createPost(
      userId: userId,
      title: title,
      body: body,
    );
  }
}




class GetGithubRepositoryUseCase {
  final GithubApiRepository _repository;

  GetGithubRepositoryUseCase(this._repository);

  Future<GithubRepository> call(String owner, String repo) {
    return _repository.getRepository(owner, repo);
  }
}

class SearchGithubRepositoriesUseCase {
  final GithubApiRepository _repository;

  SearchGithubRepositoriesUseCase(this._repository);

  Future<GithubSearchResult> call({
    required String query,
    String? language,
    String sort = 'stars',
    String order = 'desc',
    int perPage = 10,
    int page = 1,
  }) {
    return _repository.searchRepositories(
      query: query,
      language: language,
      sort: sort,
      order: order,
      perPage: perPage,
      page: page,
    );
  }
}

class GetGithubUserRepositoriesUseCase {
  final GithubApiRepository _repository;

  GetGithubUserRepositoriesUseCase(this._repository);

  Future<List<GithubRepository>> call(String username) {
    return _repository.getUserRepositories(username);
  }
}

class GetTrendingRepositoriesUseCase {
  final GithubApiRepository _repository;

  GetTrendingRepositoriesUseCase(this._repository);

  Future<GithubSearchResult> call({String? language, int perPage = 10}) {
    return _repository.getTrendingRepositories(
      language: language,
      perPage: perPage,
    );
  }
}
