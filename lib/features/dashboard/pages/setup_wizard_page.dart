import 'package:flutter/material.dart';
import 'package:project/features/dashboard/pages/home_page.dart';

class UpdateWizardPage extends StatelessWidget {
  const UpdateWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Мастер обновления'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.system_update,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Добро пожаловать в мастер обновления!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Мы поможем вам обновить систему за несколько простых шагов.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(isActive: true, isCompleted: false),
                    Container(width: 40, height: 2, color: Colors.grey.shade300),
                    _buildStepIndicator(isActive: false, isCompleted: false),
                    Container(width: 40, height: 2, color: Colors.grey.shade300),
                    _buildStepIndicator(isActive: false, isCompleted: false),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WizardStep2Page()),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Начать обновление'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required bool isActive, required bool isCompleted}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.deepPurple : (isCompleted ? Colors.green : Colors.grey.shade300),
      ),
      child: Icon(
        isCompleted ? Icons.check : Icons.circle,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}

class WizardStep2Page extends StatelessWidget {
  const WizardStep2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Мастер обновления - Шаг 2'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UpdateWizardPage()),
            );
          },
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Загрузка обновлений',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Загружаем последние обновления для вашей системы.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(isActive: false, isCompleted: true),
                    Container(width: 40, height: 2, color: Colors.green),
                    _buildStepIndicator(isActive: true, isCompleted: false),
                    Container(width: 40, height: 2, color: Colors.grey.shade300),
                    _buildStepIndicator(isActive: false, isCompleted: false),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WizardStep3Page()),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Продолжить'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required bool isActive, required bool isCompleted}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.deepPurple : (isCompleted ? Colors.green : Colors.grey.shade300),
      ),
      child: Icon(
        isCompleted ? Icons.check : Icons.circle,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}

class WizardStep3Page extends StatelessWidget {
  const WizardStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Мастер обновления - Шаг 3'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WizardStep2Page()),
            );
          },
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Обновление завершено!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Система успешно обновлена. Теперь можно начать работу.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(isActive: false, isCompleted: true),
                    Container(width: 40, height: 2, color: Colors.green),
                    _buildStepIndicator(isActive: false, isCompleted: true),
                    Container(width: 40, height: 2, color: Colors.green),
                    _buildStepIndicator(isActive: true, isCompleted: false),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Вернуться на главный экран'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required bool isActive, required bool isCompleted}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.deepPurple : (isCompleted ? Colors.green : Colors.grey.shade300),
      ),
      child: Icon(
        isCompleted ? Icons.check : Icons.circle,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}

