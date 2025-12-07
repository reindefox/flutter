import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/widgets/content_page.dart';
import '../../../core/models/container_model.dart';
import '../../../domain/usecases/container_usecases.dart';
import '../../../shared/di/service_locator.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final TextEditingController _controller = TextEditingController();
  
  late final GetContainersUseCase _getContainers;
  late final GetAvailableContainersUseCase _getAvailableContainers;
  late final AddAvailableContainerUseCase _addAvailableContainer;
  late final AddContainerToManagedUseCase _addContainerToManaged;
  late final StartContainerUseCase _startContainer;
  late final StopContainerUseCase _stopContainer;
  late final RemoveContainerUseCase _removeContainer;

  List<ContainerModel> _containers = [];
  List<String> _availableContainers = [];
  StreamSubscription? _containersSub;
  StreamSubscription? _availableSub;

  @override
  void initState() {
    super.initState();
    _getContainers = getIt<GetContainersUseCase>();
    _getAvailableContainers = getIt<GetAvailableContainersUseCase>();
    _addAvailableContainer = getIt<AddAvailableContainerUseCase>();
    _addContainerToManaged = getIt<AddContainerToManagedUseCase>();
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
    _containersSub?.cancel();
    _availableSub?.cancel();
    super.dispose();
  }

  Color _statusColor(bool running) {
    return running ? Colors.green : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Docker контейнеры',
      color: Colors.blue,
      body: Padding(
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
                    subtitle: Text(
                      container.log,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
