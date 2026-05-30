import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PatternSequenceGame extends StatefulWidget {
  const PatternSequenceGame({super.key});

  @override
  State<PatternSequenceGame> createState() => _PatternSequenceGameState();
}

class _PatternSequenceGameState extends State<PatternSequenceGame> {
  final Random _random = Random();
  final List<int> _sequence = <int>[];
  final List<int> _input = <int>[];

  bool _showing = true;
  int _flashIndex = -1;
  int _tappedIndex = -1;

  @override
  void initState() {
    super.initState();
    _sequence.addAll(List<int>.generate(3, (_) => _random.nextInt(9)));
    _playSequence();
  }

  Future<void> _playSequence() async {
    setState(() {
      _showing = true;
      _input.clear();
      _flashIndex = -1;
      _tappedIndex = -1;
    });

    await Future<void>.delayed(const Duration(milliseconds: 300));

    for (final index in _sequence) {
      if (!mounted) {
        return;
      }
      setState(() => _flashIndex = index);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) {
        return;
      }
      setState(() => _flashIndex = -1);
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }

    if (!mounted) {
      return;
    }
    setState(() => _showing = false);
  }

  Future<void> _onTap(int index) async {
    if (_showing || _tappedIndex != -1) {
      return;
    }

    // Dynamic responsive tap feedback
    setState(() => _tappedIndex = index);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    setState(() => _tappedIndex = -1);

    _input.add(index);
    final position = _input.length - 1;

    if (_sequence[position] != index) {
      await _playSequence();
      return;
    }

    if (_input.length == _sequence.length) {
      _sequence.add(_random.nextInt(9));
      await _playSequence();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            _showing ? 'Watch the light pattern' : 'Repeat the pattern',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text('Pattern length: ${_sequence.length}'),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final highlighted = _flashIndex == index || _tappedIndex == index;
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: highlighted ? AppTheme.accent : AppTheme.surface,
                      border: Border.all(
                        color: highlighted ? AppTheme.accent : AppTheme.surfaceAlt,
                        width: 2,
                      ),
                      boxShadow: highlighted
                          ? [
                              BoxShadow(
                                color: AppTheme.accent.withValues(alpha: 0.65),
                                blurRadius: 18,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
