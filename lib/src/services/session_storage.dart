import 'dart:convert';
import 'dart:io';

import '../models/resync_session.dart';

class SessionStorage {
  SessionStorage._();

  static const String _fileName = 'resync_sessions.json';

  static Future<File> _storageFile() async {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    final base = localAppData != null && localAppData.isNotEmpty
        ? Directory('$localAppData\\resync')
        : Directory('${Directory.systemTemp.path}\\resync');
    if (!await base.exists()) {
      await base.create(recursive: true);
    }
    return File('${base.path}\\$_fileName');
  }

  static Future<List<ResyncSession>> loadSessions() async {
    final file = await _storageFile();
    if (!await file.exists()) {
      return <ResyncSession>[];
    }

    final text = await file.readAsString();
    if (text.trim().isEmpty) {
      return <ResyncSession>[];
    }

    final raw = jsonDecode(text) as List<dynamic>;
    final parsed = raw
        .map((item) => ResyncSession.fromMap(item as Map<String, dynamic>))
        .toList();
    parsed.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return parsed;
  }

  static Future<void> saveSession(ResyncSession session) async {
    final file = await _storageFile();
    final current = await loadSessions();
    final updated = <ResyncSession>[session, ...current];
    final payload = updated.map((e) => e.toMap()).toList();
    await file.writeAsString(jsonEncode(payload));
  }
}
