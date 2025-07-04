import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/timer_service.dart';
import '../models/session_model.dart';

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({super.key});

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  String _sessionLabel(SessionType type) {
    switch (type) {
      case SessionType.pomodoro:
        return 'Pomodoro';
      case SessionType.shortBreak:
        return 'Pause courte';
      case SessionType.longBreak:
        return 'Pause longue';
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Toggle Modern Stylisé
          ToggleButtons(
            isSelected: [
              timerService.currentType == SessionType.pomodoro,
              timerService.currentType == SessionType.shortBreak,
              timerService.currentType == SessionType.longBreak,
            ],
            onPressed: (index) {
              timerService.setSessionType(SessionType.values[index]);
            },
            borderRadius: BorderRadius.circular(12),
            selectedColor: Colors.white,
            fillColor: Colors.redAccent,
            color: Colors.white60,
            borderColor: Colors.grey[700],
            selectedBorderColor: Colors.redAccent,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text('Pomodoro'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text('Pause courte'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text('Pause longue'),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Timer affiché
          Text(
            _formatTime(timerService.remainingTime),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          // Boutons modernes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(
                    timerService.isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(timerService.isRunning ? 'Pause' : 'Démarrer'),
                onPressed: timerService.isRunning
                    ? timerService.pauseTimer
                    : timerService.startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.restart_alt),
                label: const Text('Réinitialiser'),
                onPressed: timerService.resetTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Mode actuel : ${_sessionLabel(timerService.currentType)}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
