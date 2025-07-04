enum SessionType { pomodoro, shortBreak, longBreak }

class Session {
  final String? id;
  final DateTime startTime;
  final int duration;
  final SessionType type;

  Session({
    this.id,
    required this.startTime,
    required this.duration,
    required this.type,
  });

  Map<String, dynamic> toMap({String? userId}) {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'start_time': startTime.toIso8601String(),
      'duration': duration,
      'type': type.name,
    };
  }

  static Session fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      startTime: DateTime.parse(map['start_time']),
      duration: map['duration'],
      type: SessionType.values.firstWhere((e) => e.name == map['type']),
    );
  }
}
