import 'package:flutter/material.dart';

import '../models/resync_session.dart';
import '../services/session_storage.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<ResyncSession>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = SessionStorage.loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder<List<ResyncSession>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final now = DateTime.now();
          final sessions = snapshot.data!
              .where((s) => now.difference(s.startedAt).inDays <= 30)
              .toList();

          if (sessions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No sessions yet. Start from the main button to create your first session.'),
              ),
            );
          }

          final avgDelta = sessions
                  .map((s) => s.delta)
                  .reduce((a, b) => a + b) /
              sessions.length;
          final avgDuration = sessions
                  .map((s) => s.durationSeconds)
                  .reduce((a, b) => a + b) /
              sessions.length;
          final gameCounts = <String, int>{};
          for (final s in sessions) {
            gameCounts[s.gameType] = (gameCounts[s.gameType] ?? 0) + 1;
          }
          final mostPlayed = gameCounts.entries
              .reduce((a, b) => a.value >= b.value ? a : b)
              .key;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Personal Regulation Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.headingTeal,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Track your emotional grounding sessions and progress over the past 30 days.',
                style: TextStyle(color: AppTheme.muted, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    title: 'Average Mood Delta',
                    value: avgDelta.toStringAsFixed(1),
                    subtitle: 'Higher is better',
                  ),
                  _StatCard(
                    title: 'Average Session',
                    value: '${avgDuration.round()} seconds',
                    subtitle: 'Target 2-5 minutes',
                  ),
                  _StatCard(
                    title: 'Most Played',
                    value: mostPlayed,
                    subtitle: 'Within the last 30 days',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('30-Day Progress', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: sessions.take(8).map((s) {
                      final level = (s.delta.clamp(0, 10)) / 10;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${s.gameType} (${s.preMood}->${s.postMood})',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinearProgressIndicator(
                                  minHeight: 10,
                                  value: level,
                                  backgroundColor: AppTheme.surfaceAlt,
                                  valueColor: const AlwaysStoppedAnimation(AppTheme.calm),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
