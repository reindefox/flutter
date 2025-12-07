import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/models/log_entry_model.dart';
import '../../../domain/usecases/log_usecases.dart' show GetAllLogsUseCase;
import '../../../shared/di/service_locator.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late final GetAllLogsUseCase _getAllLogs;

  List<LogEntryModel> _allLogs = [];
  LogType? _selectedType;
  StreamSubscription? _logsSub;

  @override
  void initState() {
    super.initState();
    _getAllLogs = getIt<GetAllLogsUseCase>();

    _loadLogs();
    _subscribeToChanges();
  }

  Future<void> _loadLogs() async {
    final logs = await _getAllLogs();
    setState(() => _allLogs = logs);
  }

  void _subscribeToChanges() {
    _logsSub = _getAllLogs.watch().listen((logs) {
      setState(() => _allLogs = logs);
    });
  }

  @override
  void dispose() {
    _logsSub?.cancel();
    super.dispose();
  }

  List<LogEntryModel> get _filteredLogs {
    if (_selectedType == null) return _allLogs;
    return _allLogs.where((log) => log.type == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Логи'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                const Text('Тип логов:'),
                const SizedBox(width: 12),
                DropdownButton<LogType?>(
                  value: _selectedType,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Все')),
                    ...LogType.values.map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedType = v),
                ),
                const Spacer(),
                Text('${_filteredLogs.length} записей'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _filteredLogs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = _filteredLogs[index];
                return ListTile(
                  leading: Icon(
                    _iconForType(entry.type),
                    color: _colorForType(entry.type),
                  ),
                  title: Text(entry.fullActionText),
                  subtitle: Text(entry.formattedTimestamp),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(LogType type) {
    switch (type) {
      case LogType.containers:
        return Icons.dns;
      case LogType.services:
        return Icons.settings;
      case LogType.pings:
        return Icons.network_ping;
      case LogType.system:
        return Icons.computer;
    }
  }

  Color _colorForType(LogType type) {
    switch (type) {
      case LogType.containers:
        return Colors.blue;
      case LogType.services:
        return Colors.orange;
      case LogType.pings:
        return Colors.green;
      case LogType.system:
        return Colors.grey;
    }
  }
}
