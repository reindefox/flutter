import 'package:flutter/material.dart';
import 'package:project/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swapper',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Главный экран'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Выберите страницу для просмотра',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            buildNavigationButton(context, 'Column', WidgetColumnPage()),
            buildNavigationButton(context, 'ListView', ListViewPage()),
            buildNavigationButton(context, 'ListView.separated', ListViewSeparatedPage()),
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  final String title;
  final Color color;
  final Widget body;

  const ContentPage({
    super.key,
    required this.title,
    required this.color,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.withValues(alpha: 0.8),
        title: Text(title),
      ),
      body: body,
    );
  }
}

// class ListRemoveExamplePage extends StatefulWidget {
//   const ListRemoveExamplePage({super.key});
//
//   @override
//   State<ListRemoveExamplePage> createState() => _ListRemoveExamplePageState();
// }
//
// class _ListRemoveExamplePageState extends State<ListRemoveExamplePage> {
//   final items = List.generate(100, (index) => 'Item ${index + 1}');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: items
//             .map(
//               (item) => GestureDetector(
//                 key: ValueKey(item), // <----
//                 onTap: () => setState(() => items.remove(item)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(item),
//                 ),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }
