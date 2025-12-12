

class GithubRepository {
  final int id;
  final String name;
  final String fullName;
  final GithubOwner owner;
  final String? description;
  final bool private;
  final String htmlUrl;
  final String? language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final String? defaultBranch;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GithubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.owner,
    this.description,
    required this.private,
    required this.htmlUrl,
    this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    this.defaultBranch,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GithubRepository.fromJson(Map<String, dynamic> json) {
    return GithubRepository(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      owner: GithubOwner.fromJson(json['owner'] as Map<String, dynamic>),
      description: json['description'] as String?,
      private: json['private'] as bool,
      htmlUrl: json['html_url'] as String,
      language: json['language'] as String?,
      stargazersCount: json['stargazers_count'] as int,
      watchersCount: json['watchers_count'] as int,
      forksCount: json['forks_count'] as int,
      openIssuesCount: json['open_issues_count'] as int,
      defaultBranch: json['default_branch'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'owner': owner.toJson(),
      'description': description,
      'private': private,
      'html_url': htmlUrl,
      'language': language,
      'stargazers_count': stargazersCount,
      'watchers_count': watchersCount,
      'forks_count': forksCount,
      'open_issues_count': openIssuesCount,
      'default_branch': defaultBranch,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedStars {
    if (stargazersCount >= 1000) {
      return '${(stargazersCount / 1000).toStringAsFixed(1)}k';
    }
    return stargazersCount.toString();
  }
}

class GithubOwner {
  final int id;
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final String type;

  const GithubOwner({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.type,
  });

  factory GithubOwner.fromJson(Map<String, dynamic> json) {
    return GithubOwner(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
      'type': type,
    };
  }
}

class GithubSearchResult {
  final int totalCount;
  final bool incompleteResults;
  final List<GithubRepository> items;

  const GithubSearchResult({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory GithubSearchResult.fromJson(Map<String, dynamic> json) {
    return GithubSearchResult(
      totalCount: json['total_count'] as int,
      incompleteResults: json['incomplete_results'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((item) => GithubRepository.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
