import 'package:flutter/material.dart';
import '../models/session_model.dart' as model;
import '../services/supabase_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<model.Session> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final List<model.Session> data = await SupabaseService.getUserSessions();
    setState(() {
      _sessions = data;
    });
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String formatDuration(int seconds) {
    final m = seconds ~/ 60;
    return '$m minutes';
  }

  Color getTypeColor(model.SessionType type) {
    switch (type) {
      case model.SessionType.pomodoro:
        return Colors.redAccent;
      case model.SessionType.shortBreak:
        return Colors.lightBlueAccent;
      case model.SessionType.longBreak:
        return Colors.greenAccent;
    }
  }

  IconData getTypeIcon(model.SessionType type) {
    switch (type) {
      case model.SessionType.pomodoro:
        return Icons.timer;
      case model.SessionType.shortBreak:
        return Icons.coffee;
      case model.SessionType.longBreak:
        return Icons.self_improvement;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des sessions'),
        centerTitle: true,
      ),
      body: _sessions.isEmpty
          ? const Center(child: Text('Aucune session enregistrée.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                final color = getTypeColor(session.type);

                return Card(
                  color: color.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: color, width: 1.5),
                  ),
                  child: ListTile(
                    leading: Icon(
                      getTypeIcon(session.type),
                      color: color,
                      size: 30,
                    ),
                    title: Text(
                      session.type.name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color.darken(0.3),
                      ),
                    ),
                    subtitle: Text(
                      '${formatDate(session.startTime)}\nDurée : ${formatDuration(session.duration)}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
