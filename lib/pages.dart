import 'package:flutter/material.dart';
import 'main.dart';

class WidgetColumnPage extends StatefulWidget {
  const WidgetColumnPage({super.key});

  @override
  State<WidgetColumnPage> createState() => _WidgetColumnPageState();
}

class _WidgetColumnPageState extends State<WidgetColumnPage> {
  final List<String> items = [];

  void _addItem() {
    setState(() {
      items.add('Элемент ${items.length + 1}');
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Column',
      color: Colors.green,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _addItem, child: const Text('Добавить')),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    ListTile(
                      title: Text(items[i]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final List<String> items = [];

  void _addItem() {
    setState(() {
      items.add('Элемент ${items.length + 1}');
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'ListView',
      color: Colors.blue,
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _addItem, child: const Text('Добавить')),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ListViewSeparatedPage extends StatefulWidget {
  const ListViewSeparatedPage({super.key});

  @override
  State<ListViewSeparatedPage> createState() => _ListViewSeparatedPageState();
}

class _ListViewSeparatedPageState extends State<ListViewSeparatedPage> {
  final List<String> items = [];

  void _addItem() {
    setState(() {
      items.add('Элемент ${items.length + 1}');
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'ListView.separated',
      color: Colors.purple,
      body: Column(
        children: [
          const SizedBox(height: 5),
          ElevatedButton(onPressed: _addItem, child: const Text('Добавить')),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ListCreatePage extends StatelessWidget {
//   final items = List.generate(100, (index) => 'Item ${index + 1}');
//
//   ListCreatePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ContentPage(
//       title: "Создание списков",
//       color: Colors.grey,
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: items.map((item) => Text(item)).toList(),
//         ),
//       ),
//     );
//   }
// }
//
// class ListViewBuilder extends StatelessWidget {
//   final items = List.generate(100, (index) => 'Item ${index + 1}');
//
//   ListViewBuilder({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ContentPage(
//       title: "Создание списков",
//       color: Colors.grey,
//       body: ListView.builder(
//         itemBuilder: (_, position) => Text(items[position]),
//         itemCount: items.length,
//       ),
//     );
//   }
// }
//
// class ListViewSeparated extends StatelessWidget {
//   final items = List.generate(100, (index) => 'Item ${index + 1}');
//
//   ListViewSeparated({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ContentPage(
//       title: "Создание списков",
//       color: Colors.grey,
//       body: ListView.separated(
//           itemBuilder: (_, position) => Text(items[position]),
//           separatorBuilder: (_, __) => const Divider(),
//           itemCount: items.length
//       )
//     );
//   }
// }

