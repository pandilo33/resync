import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RhythmTracerGame extends StatefulWidget {
  const RhythmTracerGame({super.key});

  @override
  State<RhythmTracerGame> createState() => _RhythmTracerGameState();
}

class _RhythmTracerGameState extends State<RhythmTracerGame> {
  static const double _baseSpeed = 0.18;

  Timer? _ticker;
  double _progress = 0;
  bool _engaged = false;
  DateTime _lastTick = DateTime.now();
  final DateTime _startedAt = DateTime.now();
  Offset _finger = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 16), _tick);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _tick(Timer timer) {
    final now = DateTime.now();
    final dt = now.difference(_lastTick).inMilliseconds / 1000;
    _lastTick = now;

    final elapsed = now.difference(_startedAt).inSeconds.toDouble();
    final reduction = 0.3 * (elapsed / 120).clamp(0, 1);
    final speed = _baseSpeed * (1 - reduction);

    if (_engaged) {
      setState(() => _progress = (_progress + (speed * dt)) % 1);
    }
  }

  Offset _pointAt(double t, Size size) {
    final x = size.width * t;
    final yCenter = size.height * 0.5;
    final y = yCenter + sin(t * 4 * pi) * (size.height * 0.2);
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final drawSize = Size(constraints.maxWidth, constraints.maxHeight - 20);
        final target = _pointAt(_progress, drawSize);

        return GestureDetector(
          onPanStart: (details) {
            _finger = details.localPosition;
            final distance = (_finger - target).distance;
            setState(() => _engaged = distance <= 36);
          },
          onPanUpdate: (details) {
            _finger = details.localPosition;
            final distance = (_finger - target).distance;
            setState(() => _engaged = distance <= 36);
          },
          onPanEnd: (_) => setState(() => _engaged = false),
          child: Stack(
            children: [
              CustomPaint(
                size: drawSize,
                painter: _RhythmPainter(progress: _progress),
              ),
              Positioned(
                left: target.dx - 14,
                top: target.dy - 14,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _engaged ? AppTheme.calm : AppTheme.accentSoft,
                    boxShadow: [
                      BoxShadow(
                        color: (_engaged ? AppTheme.calm : AppTheme.accentSoft)
                            .withValues(alpha: 0.7),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(_engaged ? 'Terhubung, ikuti alur' : 'Sentuh titik untuk melanjutkan'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RhythmPainter extends CustomPainter {
  const _RhythmPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final yCenter = size.height * 0.5;

    path.moveTo(0, yCenter);
    for (double x = 0; x <= size.width; x += 1) {
      final t = x / size.width;
      final y = yCenter + sin(t * 4 * pi) * (size.height * 0.2);
      path.lineTo(x, y);
    }

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = AppTheme.surfaceAlt;
    canvas.drawPath(path, base);

    final metric = path.computeMetrics().first;
    final activePath = metric.extractPath(0, metric.length * progress);

    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.accentSoft;
    canvas.drawPath(activePath, active);
  }

  @override
  bool shouldRepaint(covariant _RhythmPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
