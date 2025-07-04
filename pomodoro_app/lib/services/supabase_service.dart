import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/session_model.dart' as model;


class SupabaseService {
  static final _client = Supabase.instance.client;

  static Future<void> saveSession(model.Session session) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('sessions').insert(session.toMap(userId: user.id));
  }

  static Future<List<model.Session>> getUserSessions() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('sessions')
        .select()
        .eq('user_id', user.id)
        .order('start_time', ascending: false);

    return (response as List).map((e) => model.Session.fromMap(e)).toList();
  }
}
