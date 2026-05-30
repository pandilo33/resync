import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CategorizationGame extends StatefulWidget {
  const CategorizationGame({super.key});

  @override
  State<CategorizationGame> createState() => _CategorizationGameState();
}

class _CategorizationGameState extends State<CategorizationGame> {
  final Random _random = Random();
  int _activeColor = 0;
  int _glowBin = -1;

  final List<Color> _colors = const [
    Color(0xFF1976D2), // Bold distinct Royal Blue
    Color(0xFF388E3C), // Bold distinct Grass Green
    Color(0xFFF57C00), // Bold distinct Orange
  ];

  @override
  void initState() {
    super.initState();
    _spawnNext();
  }

  void _spawnNext() {
    setState(() {
      _activeColor = _random.nextInt(_colors.length);
      _glowBin = -1;
    });
  }

  void _onDrop(int binIndex) {
    final isCorrect = binIndex == _activeColor;
    if (isCorrect) {
      setState(() => _glowBin = binIndex);
      Future<void>.delayed(const Duration(milliseconds: 220), _spawnNext);
    } else {
      _spawnNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text('Drag the shape to the matching color'),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Draggable<int>(
                data: _activeColor,
                feedback: _ShapeToken(color: _colors[_activeColor], scale: 1.15),
                childWhenDragging: const SizedBox.shrink(),
                child: _ShapeToken(color: _colors[_activeColor]),
              ),
            ),
          ),
          Row(
            children: List.generate(_colors.length, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DragTarget<int>(
                    onAcceptWithDetails: (_) => _onDrop(index),
                    builder: (context, candidateData, rejectedData) {
                      final shouldGlow = _glowBin == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 84,
                        decoration: BoxDecoration(
                          color: _colors[index].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _colors[index],
                            width: 2,
                          ),
                          boxShadow: shouldGlow
                              ? [
                                  BoxShadow(
                                    color: AppTheme.accentSoft.withValues(alpha: 0.6),
                                    blurRadius: 24,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ShapeToken extends StatelessWidget {
  const _ShapeToken({
    required this.color,
    this.scale = 1,
  });

  final Color color;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
