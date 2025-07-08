import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/session_model.dart';
import '../services/timer_service.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  final FocusNode _focusNode = FocusNode();

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

  void _handleKey(KeyEvent event, TimerService timer) {
    if (event is KeyDownEvent) {
      final isCtrl = HardwareKeyboard.instance.logicalKeysPressed
          .contains(LogicalKeyboardKey.controlLeft);

      if (isCtrl) {
        if (event.logicalKey == LogicalKeyboardKey.keyS) {
          timer.isRunning ? timer.pauseTimer() : timer.startTimer();
        } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
          timer.resetTimer();
        } else if (event.logicalKey == LogicalKeyboardKey.digit1) {
          timer.setSessionType(SessionType.pomodoro);
        } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
          timer.setSessionType(SessionType.shortBreak);
        } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
          timer.setSessionType(SessionType.longBreak);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        final timer = Provider.of<TimerService>(context, listen: false);
        _handleKey(event, timer);
      },
      child: Consumer<TimerService>(
        builder: (context, timer, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                isSelected: [
                  timer.currentType == SessionType.pomodoro,
                  timer.currentType == SessionType.shortBreak,
                  timer.currentType == SessionType.longBreak,
                ],
                onPressed: (index) {
                  final types = SessionType.values;
                  timer.setSessionType(types[index]);
                },
                borderRadius: BorderRadius.circular(16),
                selectedColor: Colors.white,
                fillColor: const Color(0xFFEF5350), 
                color: Colors.grey[600],
                textStyle: const TextStyle(fontFamily: 'Poppins'),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('Pomodoro'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('Pause'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('Long Break'),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                _formatTime(timer.remainingTime),
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: Color(0xFF388E3C), 
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: timer.isRunning
                        ? timer.pauseTimer
                        : timer.startTimer,
                    icon: Icon(
                      timer.isRunning ? Icons.pause : Icons.play_arrow,
                      size: 24,
                    ),
                    label: Text(timer.isRunning ? 'Pause' : 'Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF5350),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: timer.resetTimer,
                    icon: const Icon(Icons.restart_alt, size: 24),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66BB6A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Mode actuel : ${_sessionLabel(timer.currentType)}',
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                '🎹 Ctrl+S: Start/Pause  |  Ctrl+R: Reset  |  Ctrl+1/2/3: Mode',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic),
              ),
            ],
          );
        },
      ),
    );
  }
}
