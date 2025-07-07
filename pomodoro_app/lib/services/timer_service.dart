import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/session_model.dart';
import 'supabase_service.dart';

class TimerService extends ChangeNotifier {
  Map<SessionType, int> durations = {
    SessionType.pomodoro: 25 * 60,
    SessionType.shortBreak: 5 * 60,
    SessionType.longBreak: 15 * 60,
  };

  late SessionType _currentType;
  int _remainingTime = 0;
  Timer? _timer;
  bool _isRunning = false;

  final _player = AudioPlayer();
  final _notifications = FlutterLocalNotificationsPlugin();

  TimerService() {
    _currentType = SessionType.pomodoro;
    _loadCustomDurations();
    _initializeNotifications();
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

  Future<void> _saveSession() async {
    final session = Session(
      startTime: DateTime.now(),
      duration: durations[_currentType]!,
      type: _currentType,
    );

    await SupabaseService.saveSession(session);

    // 🔊 Son
    await _player.play(AssetSource('sounds/ding.mp3'));

    // 🔔 Notification (Android uniquement)
    await _notifications.show(
      0,
      'Session terminée',
      'La session ${_sessionLabel(_currentType)} est terminée.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_channel',
          'Pomodoro Notifications',
          channelDescription: 'Notification à la fin d\'une session Pomodoro',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  String _sessionLabel(SessionType type) {
    switch (type) {
      case SessionType.pomodoro:
        return 'Pomodoro';
      case SessionType.shortBreak:
        return 'pause courte';
      case SessionType.longBreak:
        return 'pause longue';
    }
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _notifications.initialize(settings);
  }

  Future<void> _loadCustomDurations() async {
    final prefs = await SharedPreferences.getInstance();

    durations[SessionType.pomodoro] =
        (prefs.getInt('pomodoroDuration') ?? 25) * 60;
    durations[SessionType.shortBreak] =
        (prefs.getInt('shortBreakDuration') ?? 5) * 60;
    durations[SessionType.longBreak] =
        (prefs.getInt('longBreakDuration') ?? 15) * 60;

    _remainingTime = durations[_currentType]!;
    notifyListeners();
  }

  Future<void> reloadDurations() async {
    await _loadCustomDurations();
    resetTimer();
  }
}
