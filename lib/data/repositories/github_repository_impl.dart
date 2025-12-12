import 'package:project/core/models/api/api_models.dart';
import 'package:project/data/datasources/remote/github_datasource.dart';
import 'package:project/domain/repositories/api_repository.dart';

class GithubApiRepositoryImpl implements GithubApiRepository {
  final GithubDataSource _dataSource;

  GithubApiRepositoryImpl(this._dataSource);

  @override
  Future<GithubRepository> getRepository(String owner, String repo) {
    return _dataSource.getRepository(owner, repo);
  }

  @override
  Future<GithubSearchResult> searchRepositories({
    required String query,
    String? language,
    String sort = 'stars',
    String order = 'desc',
    int perPage = 10,
    int page = 1,
  }) {
    return _dataSource.searchRepositories(
      query: query,
      language: language,
      sort: sort,
      order: order,
      perPage: perPage,
      page: page,
    );
  }

  @override
  Future<List<GithubRepository>> getUserRepositories(String username) {
    return _dataSource.getUserRepositories(username);
  }

  @override
  Future<GithubSearchResult> getTrendingRepositories({
    String? language,
    int perPage = 10,
  }) {
    return _dataSource.getTrendingRepositories(
      language: language,
      perPage: perPage,
    );
  }
}
