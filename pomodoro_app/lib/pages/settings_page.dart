import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _pomodoroController = TextEditingController();
  final _shortBreakController = TextEditingController();
  final _longBreakController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDurations();
  }

  Future<void> _loadDurations() async {
    final prefs = await SharedPreferences.getInstance();
    _pomodoroController.text =
        (prefs.getInt('pomodoroDuration') ?? 25).toString();
    _shortBreakController.text =
        (prefs.getInt('shortBreakDuration') ?? 5).toString();
    _longBreakController.text =
        (prefs.getInt('longBreakDuration') ?? 15).toString();
  }

  Future<void> _saveDurations() async {
    final prefs = await SharedPreferences.getInstance();
    final pomodoro = int.tryParse(_pomodoroController.text) ?? 25;
    final shortBreak = int.tryParse(_shortBreakController.text) ?? 5;
    final longBreak = int.tryParse(_longBreakController.text) ?? 15;

    await prefs.setInt('pomodoroDuration', pomodoro);
    await prefs.setInt('shortBreakDuration', shortBreak);
    await prefs.setInt('longBreakDuration', longBreak);

    if (!mounted) return;
    Navigator.pop(context, true); // retourne à la Home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réglages des durées')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text('Durées en minutes :',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildNumberField('Pomodoro', _pomodoroController),
            _buildNumberField('Pause courte', _shortBreakController),
            _buildNumberField('Pause longue', _longBreakController),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _saveDurations,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
