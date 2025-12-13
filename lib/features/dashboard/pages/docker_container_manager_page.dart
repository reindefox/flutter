import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/widgets/content_page.dart';
import '../../../core/models/container_model.dart';
import '../../../domain/usecases/container_usecases.dart';
import '../../../domain/usecases/api_usecases.dart';
import '../../../shared/di/service_locator.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _githubSearchController = TextEditingController();
  
  late final GetContainersUseCase _getContainers;
  late final GetAvailableContainersUseCase _getAvailableContainers;
  late final AddAvailableContainerUseCase _addAvailableContainer;
  late final AddContainerToManagedUseCase _addContainerToManaged;
  late final AddGithubRepositoryAsContainerUseCase _addGithubRepositoryAsContainer;
  late final SearchGithubRepositoriesUseCase _searchGithubRepositories;
  late final StartContainerUseCase _startContainer;
  late final StopContainerUseCase _stopContainer;
  late final RemoveContainerUseCase _removeContainer;

  List<ContainerModel> _containers = [];
  List<String> _availableContainers = [];
  StreamSubscription? _containersSub;
  StreamSubscription? _availableSub;
  bool _isSearchingGithub = false;
  List<dynamic> _githubSearchResults = [];

  @override
  void initState() {
    super.initState();
    _getContainers = getIt<GetContainersUseCase>();
    _getAvailableContainers = getIt<GetAvailableContainersUseCase>();
    _addAvailableContainer = getIt<AddAvailableContainerUseCase>();
    _addContainerToManaged = getIt<AddContainerToManagedUseCase>();
    _addGithubRepositoryAsContainer = getIt<AddGithubRepositoryAsContainerUseCase>();
    _searchGithubRepositories = getIt<SearchGithubRepositoriesUseCase>();
    _startContainer = getIt<StartContainerUseCase>();
    _stopContainer = getIt<StopContainerUseCase>();
    _removeContainer = getIt<RemoveContainerUseCase>();

    _loadData();
    _subscribeToChanges();
  }

  Future<void> _loadData() async {
    final containers = await _getContainers();
    final available = await _getAvailableContainers();
    setState(() {
      _containers = containers;
      _availableContainers = available;
    });
  }

  void _subscribeToChanges() {
    _containersSub = _getContainers.watch().listen((containers) {
      setState(() => _containers = containers);
    });
    _availableSub = _getAvailableContainers.watch().listen((available) {
      setState(() => _availableContainers = available);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _githubSearchController.dispose();
    _containersSub?.cancel();
    _availableSub?.cancel();
    super.dispose();
  }

  Future<void> _searchGithubRepos() async {
    final query = _githubSearchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _githubSearchResults = [];
      });
      return;
    }

    setState(() {
      _isSearchingGithub = true;
    });

    try {
      final result = await _searchGithubRepositories(query: query, perPage: 10);
      setState(() {
        _githubSearchResults = result.items;
        _isSearchingGithub = false;
      });
    } catch (e) {
      setState(() {
        _isSearchingGithub = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка поиска: $e')),
        );
      }
    }
  }

  Future<void> _addGithubRepoAsContainer(dynamic repo) async {
    try {
      final owner = repo.owner.login;
      final repoName = repo.name;
      await _addGithubRepositoryAsContainer(owner, repoName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Репозиторий добавлен как контейнер')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  Color _statusColor(bool running) {
    return running ? Colors.green : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ContentPage(
        title: 'Docker контейнеры',
        color: Colors.blue,
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Контейнеры', icon: Icon(Icons.storage)),
                Tab(text: 'Поиск GitHub', icon: Icon(Icons.search)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildContainersTab(),
                  _buildGithubSearchTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainersTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Имя контейнера',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _addAvailableContainer(_controller.text.trim());
                    _controller.clear();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return isWide
                    ? Row(
                        children: [
                          Expanded(child: _buildAvailableContainersCard()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildManagedContainersCard()),
                        ],
                      )
                    : Column(
                        children: [
                          _buildAvailableContainersCard(),
                          const SizedBox(height: 12),
                          Expanded(child: _buildManagedContainersCard()),
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGithubSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _githubSearchController,
                  decoration: const InputDecoration(
                    labelText: 'Поиск репозиториев GitHub',
                    hintText: 'Например: flutter, react, node',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _searchGithubRepos(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isSearchingGithub ? null : _searchGithubRepos,
                child: _isSearchingGithub
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Поиск'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isSearchingGithub
                ? const Center(child: CircularProgressIndicator())
                : _githubSearchResults.isEmpty
                    ? Center(
                        child: Text(
                          _githubSearchController.text.isEmpty
                              ? 'Введите запрос для поиска репозиториев'
                              : 'Результаты не найдены',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _githubSearchResults.length,
                        itemBuilder: (context, index) {
                          final repo = _githubSearchResults[index];
                          final alreadyAdded = _containers.any(
                            (c) => c.repository?.fullName == repo.fullName,
                          );
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(repo.owner.avatarUrl),
                              ),
                              title: Text(
                                repo.fullName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (repo.description != null)
                                    Text(
                                      repo.description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 16,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star, size: 16, color: Colors.amber),
                                          const SizedBox(width: 4),
                                          Text('${repo.stargazersCount}'),
                                        ],
                                      ),
                                      if (repo.language != null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.code, size: 16),
                                            const SizedBox(width: 4),
                                            Text(repo.language!),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: alreadyAdded
                                    ? null
                                    : () => _addGithubRepoAsContainer(repo),
                                child: Text(alreadyAdded ? 'Добавлен' : 'Добавить'),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableContainersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Доступные контейнеры:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _availableContainers.length,
                itemBuilder: (context, index) {
                  final name = _availableContainers[index];
                  final alreadyManaged = _containers.any((c) => c.name == name);
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    title: Text(name),
                    trailing: ElevatedButton(
                      onPressed: alreadyManaged
                          ? null
                          : () => _addContainerToManaged(name),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Добавить'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagedContainersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                'Управление контейнерами:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 4),
            Expanded(
              child: ListView.separated(
                itemCount: _containers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final container = _containers[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      container.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          container.log,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (container.repository != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.code, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              if (container.repository!.language != null)
                                Text(
                                  container.repository!.language!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              const SizedBox(width: 12),
                              Icon(Icons.star, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${container.repository!.stargazersCount}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.call_split, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${container.repository!.forksCount}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    leading: Chip(
                      label: Text(
                        container.statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: _statusColor(container.isRunning),
                      visualDensity: VisualDensity.compact,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            container.isRunning
                                ? Icons.stop_circle
                                : Icons.play_circle_fill,
                            color: container.isRunning ? Colors.red : Colors.green,
                            size: 22,
                          ),
                          tooltip: container.isRunning ? 'Остановить' : 'Запустить',
                          onPressed: () => container.isRunning
                              ? _stopContainer(container.id)
                              : _startContainer(container.id),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                            size: 20,
                          ),
                          tooltip: 'Удалить',
                          onPressed: () => _removeContainer(container.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
