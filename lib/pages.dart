import 'package:flutter/material.dart';

import 'main.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentPage(
      title: 'Информация',
      content: 'Тут какой-то текст...',
      icon: Icons.info_outline,
      color: Colors.blue,
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentPage(
      title: 'Галерея',
      content: 'Тут какой-то текст...',
      icon: Icons.photo_library,
      color: Colors.green,
    );
  }
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentPage(
      title: 'Контакты',
      content: 'Тут какой-то текст...',
      icon: Icons.contact_phone,
      color: Colors.orange,
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentPage(
      title: 'Настройки',
      content: 'Тут какой-то текст...',
      icon: Icons.settings,
      color: Colors.purple,
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentPage(
      title: 'О приложении',
      content: 'Тут какой-то текст...',
      icon: Icons.help_outline,
      color: Colors.red,
    );
  }
}
