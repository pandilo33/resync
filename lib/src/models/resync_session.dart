import 'dart:convert';

class ResyncSession {
  const ResyncSession({
    required this.id,
    required this.startedAt,
    required this.gameType,
    required this.preMood,
    required this.postMood,
    required this.durationSeconds,
  });

  final String id;
  final DateTime startedAt;
  final String gameType;
  final int preMood;
  final int postMood;
  final int durationSeconds;

  int get delta => preMood - postMood;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'startedAt': startedAt.toIso8601String(),
      'gameType': gameType,
      'preMood': preMood,
      'postMood': postMood,
      'durationSeconds': durationSeconds,
    };
  }

  factory ResyncSession.fromMap(Map<String, dynamic> map) {
    return ResyncSession(
      id: map['id'] as String,
      startedAt: DateTime.parse(map['startedAt'] as String),
      gameType: map['gameType'] as String,
      preMood: map['preMood'] as int,
      postMood: map['postMood'] as int,
      durationSeconds: map['durationSeconds'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ResyncSession.fromJson(String source) =>
      ResyncSession.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
