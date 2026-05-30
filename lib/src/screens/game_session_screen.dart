import 'dart:math';

import 'package:flutter/material.dart';

import '../games/categorization_game.dart';
import '../games/pattern_sequence_game.dart';
import '../games/rhythm_tracer_game.dart';
import '../models/resync_session.dart';
import '../services/session_storage.dart';
import 'dashboard_screen.dart';
import 'mood_calibration_screen.dart';
import '../theme/app_theme.dart';
import 'session_recap_screen.dart';

enum GameType {
  categorization('Categorization'),
  patternSequence('Pattern Sequence'),
  rhythmTracer('Rhythm Tracer');

  const GameType(this.label);
  final String label;
}

class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({
    super.key,
    required this.preMood,
  });

  final int preMood;

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen> {
  late final DateTime _startedAt;
  late final GameType _gameType;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _gameType = GameType.values[Random().nextInt(GameType.values.length)];
  }

  Future<void> _finishSession() async {
    final postMood = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => const MoodCalibrationScreen(isPreSession: false),
      ),
    );

    if (postMood == null || !mounted) {
      return;
    }

    final session = ResyncSession(
      id: _startedAt.microsecondsSinceEpoch.toString(),
      startedAt: _startedAt,
      gameType: _gameType.label,
      preMood: widget.preMood,
      postMood: postMood,
      durationSeconds: DateTime.now().difference(_startedAt).inSeconds,
    );
    await SessionStorage.saveSession(session);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => SessionRecapScreen(session: session)),
      (route) => route.isFirst,
    );
  }

  Widget _buildGame() {
    switch (_gameType) {
      case GameType.categorization:
        return const CategorizationGame();
      case GameType.patternSequence:
        return const PatternSequenceGame();
      case GameType.rhythmTracer:
        return const RhythmTracerGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gameType.label),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
            child: OutlinedButton(
              onPressed: _finishSession,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFAECE7),
                foregroundColor: const Color(0xFF8C3A2B),
                side: const BorderSide(color: Color(0xFF8C3A2B), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'End',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: _buildGame(),
    );
  }
}
