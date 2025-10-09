import 'package:flutter/material.dart';
import 'package:project/presentation/screens/listView.dart';
import 'package:project/presentation/screens/listViewSeparated.dart';
import 'package:project/presentation/screens/widgetColumn.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Выберите страницу для просмотра',
              style: TextStyle(fontSize: 20, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            buildNavigationButton(
              context,
              'Пинги (Column)',
              WidgetColumnPage(),
            ),
            buildNavigationButton(
              context,
              'Контейнеры (ListView)',
              ListViewPage(),
            ),
            buildNavigationButton(
              context,
              'Сервисы (ListView.separated)',
              ListViewSeparatedPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationButton(
      BuildContext context,
      String text,
      Widget destination,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 250,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
