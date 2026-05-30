import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MoodCalibrationScreen extends StatefulWidget {
  const MoodCalibrationScreen({
    super.key,
    required this.isPreSession,
  });

  final bool isPreSession;

  @override
  State<MoodCalibrationScreen> createState() => _MoodCalibrationScreenState();
}

class _MoodCalibrationScreenState extends State<MoodCalibrationScreen> {
  double _sliderValue = 7;

  String _getEmojiForValue(int value) {
    if (value <= 2) return '😌';
    if (value <= 4) return '🙂';
    if (value <= 6) return '😐';
    if (value <= 8) return '😰';
    return '😩';
  }

  String _getTextForValue(int value) {
    if (value <= 2) return 'Calm & Peaceful';
    if (value <= 4) return 'Doing Okay';
    if (value <= 6) return 'Slightly Tense';
    if (value <= 8) return 'Quite Anxious';
    return 'Very Overwhelmed';
  }

  @override
  Widget build(BuildContext context) {
    final instruction = widget.isPreSession
        ? "Let's take a moment to check in.\nHow are you feeling right now?"
        : "Take a deep breath.\nHow is your mind feeling now?";
    final button = widget.isPreSession ? 'Start Resync' : 'Finish & Save';

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Calibration')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                instruction,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: AppTheme.headingTeal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getEmojiForValue(_sliderValue.round()),
                        style: const TextStyle(fontSize: 72),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getTextForValue(_sliderValue.round()),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.headingTeal,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 36),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 12,
                          trackShape: const RoundedRectSliderTrackShape(),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 14,
                            elevation: 4,
                          ),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 26),
                          showValueIndicator: ShowValueIndicator.never,
                        ),
                        child: Slider(
                          value: _sliderValue,
                          min: 1,
                          max: 10,
                          onChanged: (value) => setState(() => _sliderValue = value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Calm 😌', style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w500)),
                            Text('Overwhelmed 😰', style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_sliderValue.round()),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                button,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
