import 'dart:math';

import 'package:flutter/material.dart';

import '../games/categorization_game.dart';
import '../games/pattern_sequence_game.dart';
import '../games/rhythm_tracer_game.dart';
import '../models/resync_session.dart';
import '../services/session_storage.dart';
import 'dashboard_screen.dart';
import 'mood_calibration_screen.dart';

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
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
          IconButton(
            onPressed: _finishSession,
            icon: const Icon(Icons.stop_circle_outlined),
            tooltip: 'End Session',
            color: Colors.white70,
          ),
        ],
      ),
      body: _buildGame(),
    );
  }
}
