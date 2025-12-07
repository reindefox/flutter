import 'package:flutter/material.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: body,
    );
  }
}