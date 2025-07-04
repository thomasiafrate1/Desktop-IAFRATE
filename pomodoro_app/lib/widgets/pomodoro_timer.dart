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
        return 'Pause';
      case SessionType.longBreak:
        return 'Long Break';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerService(),
      child: Consumer<TimerService>(
        builder: (context, timerService, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Toggle entre Pomodoro / Pause / Long Break
              ToggleButtons(
                isSelected: [
                  timerService.currentType == SessionType.pomodoro,
                  timerService.currentType == SessionType.shortBreak,
                  timerService.currentType == SessionType.longBreak,
                ],
                onPressed: (index) {
                  final types = SessionType.values;
                  timerService.setSessionType(types[index]);
                },
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: Colors.redAccent,
                color: Colors.grey,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pomodoro'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pause'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Long Break'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                _formatTime(timerService.remainingTime),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: timerService.isRunning
                        ? timerService.pauseTimer
                        : timerService.startTimer,
                    child: Text(timerService.isRunning ? 'Pause' : 'Start'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: timerService.resetTimer,
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Mode actuel : ${_sessionLabel(timerService.currentType)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          );
        },
      ),
    );
  }
}
