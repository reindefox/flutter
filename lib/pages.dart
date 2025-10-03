import 'package:flutter/material.dart';

import 'main.dart';

class WidgetColumnPage extends StatelessWidget {
  const WidgetColumnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(mainAxisAlignment: MainAxisAlignment.center));
  }
}

class ListViewSeparatedPage extends StatelessWidget {
  const ListViewSeparatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(mainAxisAlignment: MainAxisAlignment.center));
  }
}

class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(mainAxisAlignment: MainAxisAlignment.center));
  }
}

class ListCreatePage extends StatelessWidget {
  final items = List.generate(100, (index) => 'Item ${index + 1}');

  ListCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: "Создание списков",
      color: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.map((item) => Text(item)).toList(),
        ),
      ),
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  final items = List.generate(100, (index) => 'Item ${index + 1}');

  ListViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: "Создание списков",
      color: Colors.grey,
      body: ListView.builder(
        itemBuilder: (_, position) => Text(items[position]),
        itemCount: items.length,
      ),
    );
  }
}

class ListViewSeparated extends StatelessWidget {
  final items = List.generate(100, (index) => 'Item ${index + 1}');

  ListViewSeparated({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: "Создание списков",
      color: Colors.grey,
      body: ListView.separated(
          itemBuilder: (_, position) => Text(items[position]),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: items.length
      )
    );
  }
}

