import 'package:project/core/models/api/api_models.dart';
import 'package:project/data/datasources/remote/infrastructure_datasource.dart'
    show InfrastructureStatus, InfrastructureService;

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

  Future<List<GithubBranch>> getRepositoryBranches(String owner, String repo);

  Future<List<GithubCommit>> getRepositoryCommits(String owner, String repo, {int perPage = 10});

  Future<List<GithubIssue>> getRepositoryIssues(String owner, String repo, {int perPage = 10, String state = 'open'});

  Future<List<GithubContributor>> getRepositoryContributors(String owner, String repo, {int perPage = 10});

  Future<GithubLanguages> getRepositoryLanguages(String owner, String repo);

  Future<GithubReadme> getRepositoryReadme(String owner, String repo);
}

abstract class InfrastructureRepository {
  Future<InfrastructureStatus> getMainServerStatus();
  Future<List<InfrastructureService>> getServicesStatus();
}
