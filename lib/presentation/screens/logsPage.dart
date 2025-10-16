import 'package:flutter/material.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final List<_LogEntry> _allLogs = <_LogEntry>[
    _LogEntry(
      user: 'Лев',
      action: 'запустил',
      target: 'контейнер ...',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      type: _LogType.containers,
    ),
    _LogEntry(
      user: 'Лев',
      action: 'остановил',
      target: 'контейнер ...',
      time: DateTime.now().subtract(const Duration(minutes: 22)),
      type: _LogType.containers,
    ),
    _LogEntry(
      user: 'Лев',
      action: 'перезапустил',
      target: 'сервис ...',
      time: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
      type: _LogType.services,
    ),
    _LogEntry(
      user: 'Лев',
      action: 'запустил',
      target: 'пинг сервера',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      type: _LogType.pings,
    ),
  ];

  _LogType _selectedType = _LogType.all;

  @override
  Widget build(BuildContext context) {
    final List<_LogEntry> visible = _selectedType == _LogType.all
        ? _allLogs
        : _allLogs.where((e) => e.type == _selectedType).toList();

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
                DropdownButton<_LogType>(
                  value: _selectedType,
                  items: const <DropdownMenuItem<_LogType>>[
                    DropdownMenuItem(value: _LogType.all, child: Text('Все')),
                    DropdownMenuItem(
                      value: _LogType.containers,
                      child: Text('Контейнеры'),
                    ),
                    DropdownMenuItem(
                      value: _LogType.services,
                      child: Text('Сервисы'),
                    ),
                    DropdownMenuItem(
                      value: _LogType.pings,
                      child: Text('Пинги'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _selectedType = v ?? _LogType.all),
                ),
                const Spacer(),
                Text('${visible.length} записей'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: visible.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final _LogEntry entry = visible[index];
                return ListTile(
                  leading: Icon(
                    _iconForType(entry.type),
                    color: _colorForType(entry.type),
                  ),
                  title: Text(_formatTitle(entry)),
                  subtitle: Text(_formatSubtitle(entry.time)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTitle(_LogEntry e) {
    return '${e.user} ${e.action} ${e.target}';
  }

  String _formatSubtitle(DateTime time) {
    String two(int n) => n.toString().padLeft(2, '0');
    final String day = two(time.day);
    final String month = two(time.month);
    final String year = time.year.toString().padLeft(4, '0');
    final String hour = two(time.hour);
    final String minute = two(time.minute);
    return '$day.$month.$year $hour:$minute';
  }
}

enum _LogType { all, containers, services, pings }

class _LogEntry {
  final String user;
  final String action;
  final String target;
  final DateTime time;
  final _LogType type;

  const _LogEntry({
    required this.user,
    required this.action,
    required this.target,
    required this.time,
    required this.type,
  });
}

IconData _iconForType(_LogType type) {
  switch (type) {
    case _LogType.containers:
      return Icons.dns;
    case _LogType.services:
      return Icons.settings;
    case _LogType.pings:
      return Icons.network_ping;
    case _LogType.all:
      return Icons.list_alt;
  }
}

Color _colorForType(_LogType type) {
  switch (type) {
    case _LogType.containers:
      return Colors.blue;
    case _LogType.services:
      return Colors.orange;
    case _LogType.pings:
      return Colors.green;
    case _LogType.all:
      return Colors.grey;
  }
}
