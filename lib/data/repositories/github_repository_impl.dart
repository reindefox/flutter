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

  @override
  Future<List<GithubBranch>> getRepositoryBranches(String owner, String repo) {
    return _dataSource.getRepositoryBranches(owner, repo);
  }

  @override
  Future<List<GithubCommit>> getRepositoryCommits(String owner, String repo, {int perPage = 10}) {
    return _dataSource.getRepositoryCommits(owner, repo, perPage: perPage);
  }

  @override
  Future<List<GithubIssue>> getRepositoryIssues(String owner, String repo, {int perPage = 10, String state = 'open'}) {
    return _dataSource.getRepositoryIssues(owner, repo, perPage: perPage, state: state);
  }

  @override
  Future<List<GithubContributor>> getRepositoryContributors(String owner, String repo, {int perPage = 10}) {
    return _dataSource.getRepositoryContributors(owner, repo, perPage: perPage);
  }

  @override
  Future<GithubLanguages> getRepositoryLanguages(String owner, String repo) {
    return _dataSource.getRepositoryLanguages(owner, repo);
  }

  @override
  Future<GithubReadme> getRepositoryReadme(String owner, String repo) {
    return _dataSource.getRepositoryReadme(owner, repo);
  }
}
