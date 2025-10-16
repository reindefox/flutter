import 'package:flutter/widgets.dart';

class PingState extends ChangeNotifier {
  final List<Map<String, dynamic>> pings = [];

  void sendPing() {
    final String time = DateTime.now().toLocal().toIso8601String().substring(11, 19);
    pings.add({'time': time, 'ping': null});
    notifyListeners();

    final int index = pings.length - 1;
    Future.delayed(const Duration(seconds: 1), () {
      if (index < pings.length) {
        pings[index]['ping'] = DateTime.now().millisecond % 100 + 1; // deterministic-ish without Random
        notifyListeners();
      }
    });
  }

  void clearPings() {
    pings.clear();
    notifyListeners();
  }

  void removePing(String time) {
    pings.removeWhere((ping) => ping['time'] == time);
    notifyListeners();
  }
}

class PingStateProvider extends InheritedNotifier<PingState> {
  const PingStateProvider({super.key, required super.notifier, required super.child});

  static PingState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<PingStateProvider>();
    assert(provider != null, 'PingStateProvider not found in widget tree');
    return provider!.notifier!;
  }
}


