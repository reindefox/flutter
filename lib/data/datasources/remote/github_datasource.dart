import 'package:dio/dio.dart';
import 'package:project/core/models/api/api_models.dart';
import 'package:project/core/services/dio_client.dart';






class GithubDataSource {
  static const String _baseUrl = 'https://api.github.com';
  
  final DioClient _dioClient;

  GithubDataSource(this._dioClient);


  Future<GithubRepository> getRepository(String owner, String repo) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_baseUrl/repos/$owner/$repo',
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        throw Exception('Репозиторий не найден');
      }
      
      return GithubRepository.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<GithubSearchResult> searchRepositories({
    required String query,
    String? language,
    String sort = 'stars',
    String order = 'desc',
    int perPage = 10,
    int page = 1,
  }) async {
    try {
      String searchQuery = query;
      if (language != null && language.isNotEmpty) {
        searchQuery += ' language:$language';
      }
      
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_baseUrl/search/repositories',
        queryParameters: {
          'q': searchQuery,
          'sort': sort,
          'order': order,
          'per_page': perPage,
          'page': page,
        },
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        throw Exception('Ошибка поиска');
      }
      
      return GithubSearchResult.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<List<GithubRepository>> getUserRepositories(String username) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/users/$username/repos',
        queryParameters: {
          'sort': 'updated',
          'per_page': 10,
        },
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => GithubRepository.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<GithubSearchResult> getTrendingRepositories({
    String? language,
    int perPage = 10,
  }) async {
    return searchRepositories(
      query: 'stars:>1000',
      language: language,
      sort: 'stars',
      order: 'desc',
      perPage: perPage,
    );
  }

  Future<List<GithubBranch>> getRepositoryBranches(String owner, String repo) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/repos/$owner/$repo/branches',
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => GithubBranch.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<GithubCommit>> getRepositoryCommits(String owner, String repo, {int perPage = 10}) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/repos/$owner/$repo/commits',
        queryParameters: {
          'per_page': perPage,
        },
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => GithubCommit.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<GithubIssue>> getRepositoryIssues(String owner, String repo, {int perPage = 10, String state = 'open'}) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/repos/$owner/$repo/issues',
        queryParameters: {
          'state': state,
          'per_page': perPage,
        },
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => GithubIssue.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<GithubContributor>> getRepositoryContributors(String owner, String repo, {int perPage = 10}) async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/repos/$owner/$repo/contributors',
        queryParameters: {
          'per_page': perPage,
        },
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => GithubContributor.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<GithubLanguages> getRepositoryLanguages(String owner, String repo) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_baseUrl/repos/$owner/$repo/languages',
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        throw Exception('Языки не найдены');
      }
      
      return GithubLanguages.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<GithubReadme> getRepositoryReadme(String owner, String repo) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_baseUrl/repos/$owner/$repo/readme',
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );
      
      if (response.data == null) {
        throw Exception('README не найден');
      }
      
      return GithubReadme.fromJson(response.data!);
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
          return Exception('Репозиторий не найден');
        } else if (statusCode == 403) {
          return Exception('Превышен лимит запросов к GitHub API');
        } else if (statusCode == 500) {
          return Exception('Ошибка сервера GitHub');
        }
        return Exception('Ошибка запроса: $statusCode');
      case DioExceptionType.connectionError:
        return Exception('Нет подключения к интернету');
      default:
        return Exception('Произошла ошибка: ${e.message}');
    }
  }
}
