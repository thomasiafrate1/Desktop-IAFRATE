import 'dart:async';
import 'package:flutter/material.dart';
import '../models/session_model.dart';
import 'supabase_service.dart';

class TimerService extends ChangeNotifier {
  static const Map<SessionType, int> durations = {
    SessionType.pomodoro: 10,
    SessionType.shortBreak: 5 * 60,
    SessionType.longBreak: 15 * 60,
  };

  late SessionType _currentType;
  int _remainingTime = durations[SessionType.pomodoro]!;
  Timer? _timer;
  bool _isRunning = false;

  TimerService() {
    _currentType = SessionType.pomodoro;
  }

  SessionType get currentType => _currentType;
  int get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;

  void setSessionType(SessionType type) {
    _currentType = type;
    resetTimer();
    notifyListeners();
  }

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        _saveSession();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _remainingTime = durations[_currentType]!;
    _isRunning = false;
    notifyListeners();
  }

  void _saveSession() async {
    final session = Session(
      startTime: DateTime.now(),
      duration: durations[_currentType]!,
      type: _currentType,
    );

    await SupabaseService.saveSession(session);
  }
}
