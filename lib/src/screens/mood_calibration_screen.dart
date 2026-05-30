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

  @override
  Widget build(BuildContext context) {
    final title = widget.isPreSession ? 'Pre-Session Check-In' : 'Post-Session Check-In';
    final button = widget.isPreSession ? 'Start' : 'Finish';

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Calibration')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Slide from 1 (Calm) to 10 (Overwhelmed).'),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        _sliderValue.round().toString(),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppTheme.accentSoft,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 24),
                      Slider(
                        value: _sliderValue,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: _sliderValue.round().toString(),
                        onChanged: (value) => setState(() => _sliderValue = value),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calm'),
                          Text('Overwhelmed'),
                        ],
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
              child: Text(button),
            ),
          ],
        ),
      ),
    );
  }
}
