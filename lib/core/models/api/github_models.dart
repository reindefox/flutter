

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

class GithubBranch {
  final String name;
  final String sha;
  final bool protected;

  const GithubBranch({
    required this.name,
    required this.sha,
    required this.protected,
  });

  factory GithubBranch.fromJson(Map<String, dynamic> json) {
    return GithubBranch(
      name: json['name'] as String,
      sha: json['commit']['sha'] as String,
      protected: json['protected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sha': sha,
      'protected': protected,
    };
  }
}

class GithubCommit {
  final String sha;
  final String message;
  final GithubCommitAuthor author;
  final DateTime commitDate;

  const GithubCommit({
    required this.sha,
    required this.message,
    required this.author,
    required this.commitDate,
  });

  factory GithubCommit.fromJson(Map<String, dynamic> json) {
    return GithubCommit(
      sha: json['sha'] as String,
      message: json['commit']['message'] as String,
      author: GithubCommitAuthor.fromJson(json['commit']['author'] as Map<String, dynamic>),
      commitDate: DateTime.parse(json['commit']['author']['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sha': sha,
      'message': message,
      'author': author.toJson(),
      'commitDate': commitDate.toIso8601String(),
    };
  }
}

class GithubCommitAuthor {
  final String name;
  final String email;
  final DateTime date;

  const GithubCommitAuthor({
    required this.name,
    required this.email,
    required this.date,
  });

  factory GithubCommitAuthor.fromJson(Map<String, dynamic> json) {
    return GithubCommitAuthor(
      name: json['name'] as String,
      email: json['email'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'date': date.toIso8601String(),
    };
  }
}

class GithubIssue {
  final int number;
  final String title;
  final String? body;
  final String state;
  final GithubOwner user;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GithubIssue({
    required this.number,
    required this.title,
    this.body,
    required this.state,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GithubIssue.fromJson(Map<String, dynamic> json) {
    return GithubIssue(
      number: json['number'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      state: json['state'] as String,
      user: GithubOwner.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'body': body,
      'state': state,
      'user': user.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class GithubContributor {
  final String login;
  final int contributions;
  final String avatarUrl;
  final String htmlUrl;

  const GithubContributor({
    required this.login,
    required this.contributions,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  factory GithubContributor.fromJson(Map<String, dynamic> json) {
    return GithubContributor(
      login: json['login'] as String,
      contributions: json['contributions'] as int,
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'contributions': contributions,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
    };
  }
}

class GithubLanguages {
  final Map<String, int> languages;

  const GithubLanguages({required this.languages});

  factory GithubLanguages.fromJson(Map<String, dynamic> json) {
    return GithubLanguages(languages: Map<String, int>.from(json as Map));
  }

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(languages);
  }
}

class GithubReadme {
  final String name;
  final String content;
  final String encoding;
  final String htmlUrl;

  const GithubReadme({
    required this.name,
    required this.content,
    required this.encoding,
    required this.htmlUrl,
  });

  factory GithubReadme.fromJson(Map<String, dynamic> json) {
    return GithubReadme(
      name: json['name'] as String,
      content: json['content'] as String,
      encoding: json['encoding'] as String,
      htmlUrl: json['html_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'content': content,
      'encoding': encoding,
      'html_url': htmlUrl,
    };
  }
}
