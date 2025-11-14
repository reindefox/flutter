import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../shared/widgets/content_page.dart';
import 'package:project/shared/state/container_state.dart';
import 'package:project/shared/di/service_locator.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final TextEditingController _controller = TextEditingController();
  late final ContainerState _containerState;

  @override
  void initState() {
    super.initState();
    _containerState = getIt<ContainerState>();
  }

  @override
  void dispose() {
    _controller.dispose();
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
      body: Observer(
        builder: (_) => Padding(
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
                    onPressed: () {
                      _containerState.addAvailableContainer(_controller.text.trim());
                      _controller.clear();
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
                              Expanded(
                                child: _buildAvailableContainersCard(_containerState),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: _buildManagedContainersCard(_containerState)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildAvailableContainersCard(_containerState),
                              const SizedBox(height: 12),
                              Expanded(child: _buildManagedContainersCard(_containerState)),
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableContainersCard(ContainerState state) {
    return Observer(
      builder: (_) => Card(
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
                  itemCount: state.availableContainers.length,
                  itemBuilder: (context, index) {
                    final name = state.availableContainers[index];
                    final alreadyManaged = state.containers.any(
                      (c) => c['name'] == name,
                    );
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
                            : () => state.addContainerFromAvailable(name),
                        child: const Text('Добавить'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagedContainersCard(ContainerState state) {
    return Observer(
      builder: (_) => Card(
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
                  itemCount: state.containers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final container = state.containers[index];
                    final bool running = container['running'] as bool;
                    return ListTile(
                      dense: true,
                      title: Text(
                        container['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        container['log'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Chip(
                        label: Text(
                          running ? 'Запущен' : 'Остановлен',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: _statusColor(running),
                        visualDensity: VisualDensity.compact,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              running
                                  ? Icons.stop_circle
                                  : Icons.play_circle_fill,
                              color: running ? Colors.red : Colors.green,
                              size: 22,
                            ),
                            tooltip: running ? 'Остановить' : 'Запустить',
                            onPressed: () => running
                                ? state.stopContainer(index)
                                : state.startContainer(index),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                            tooltip: 'Удалить',
                            onPressed: () => state.removeContainer(
                              container['name'] as String,
                            ),
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
      ),
    );
  }
}
