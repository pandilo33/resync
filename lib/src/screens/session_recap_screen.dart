import 'package:flutter/material.dart';
import '../models/resync_session.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class SessionRecapScreen extends StatelessWidget {
  const SessionRecapScreen({
    super.key,
    required this.session,
  });

  final ResyncSession session;

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
    final improvement = session.preMood - session.postMood;
    final minutes = session.durationSeconds ~/ 60;
    final seconds = session.durationSeconds % 60;
    final durationText = minutes > 0 ? '$minutes min $seconds sec' : '$seconds sec';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Recap'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              "Wonderful job grounding yourself!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.headingTeal,
                    fontSize: 24,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "You successfully took control and completed your exercise.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRecapRow(
                        context,
                        label: "Cognitive Focus",
                        value: session.gameType,
                        icon: Icons.psychology_outlined,
                      ),
                      const Divider(height: 32, color: AppTheme.surfaceAlt),
                      _buildRecapRow(
                        context,
                        label: "Duration",
                        value: durationText,
                        icon: Icons.timer_outlined,
                      ),
                      const Divider(height: 32, color: AppTheme.surfaceAlt),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                _getEmojiForValue(session.preMood),
                                style: const TextStyle(fontSize: 48),
                              ),
                              const SizedBox(height: 8),
                              const Text("Before", style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.headingTeal)),
                              const SizedBox(height: 4),
                              Text(
                                _getTextForValue(session.preMood),
                                style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_rounded, color: AppTheme.accent, size: 28),
                          Column(
                            children: [
                              Text(
                                _getEmojiForValue(session.postMood),
                                style: const TextStyle(fontSize: 48),
                              ),
                              const SizedBox(height: 8),
                              const Text("After", style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.headingTeal)),
                              const SizedBox(height: 4),
                              Text(
                                _getTextForValue(session.postMood),
                                style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.info,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Thank you for taking a moment for yourself! 😌",
                          style: TextStyle(
                            color: AppTheme.headingTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (route) => route.isFirst,
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text(
                'View Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecapRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.calm, size: 28),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.headingTeal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
