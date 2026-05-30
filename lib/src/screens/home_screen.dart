import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'game_session_screen.dart';
import 'mood_calibration_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _startResync(BuildContext context) async {
    final preMood = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => const MoodCalibrationScreen(isPreSession: true),
      ),
    );
    if (preMood == null || !context.mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameSessionScreen(preMood: preMood),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resync'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
            icon: const Icon(Icons.insights_outlined),
            tooltip: 'History / Dashboard',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1220), Color(0xFF111A2E), Color(0xFF1A2240)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Need grounding now?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => _startResync(context),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(240, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Resync',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
