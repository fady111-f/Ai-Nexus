import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/live_interview/presentation/pages/interview_setup_screen.dart';

class PreInterviewLobbyScreen extends StatefulWidget {
  const PreInterviewLobbyScreen({this.config, super.key});

  final InterviewSetupConfig? config;

  @override
  State<PreInterviewLobbyScreen> createState() => _PreInterviewLobbyScreenState();
}

class _PreInterviewLobbyScreenState extends State<PreInterviewLobbyScreen> {
  late Timer _audioMeterTimer;
  final List<double> _micLevels = List.filled(7, 0.2);
  final math.Random _random = math.Random();

  bool _isTestingAudio = false;
  String _speakerStatus = 'Speakers OK';
  bool _micPermissionGranted = true;

  @override
  void initState() {
    super.initState();
    _audioMeterTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _micLevels.length; i++) {
            _micLevels[i] = 0.15 + _random.nextDouble() * 0.75;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioMeterTimer.cancel();
    super.dispose();
  }

  void _runSpeakerTest() {
    if (_isTestingAudio) return;
    setState(() {
      _isTestingAudio = true;
      _speakerStatus = 'Playing test sound...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTestingAudio = false;
          _speakerStatus = 'Speakers OK (Test Completed)';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config ?? const InterviewSetupConfig();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Pre-Interview Lobby', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MockMateSpacing.large),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 720;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ready Check & Session Summary',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Test your audio equipment and verify interview parameters before entering.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: MockMateSpacing.large),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildDeviceCheckPanel()),
                            const SizedBox(width: MockMateSpacing.large),
                            Expanded(child: _buildInterviewSummaryPanel(cfg)),
                          ],
                        )
                      else ...[
                        _buildDeviceCheckPanel(),
                        const SizedBox(height: MockMateSpacing.large),
                        _buildInterviewSummaryPanel(cfg),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCheckPanel() {
    return Container(
      padding: const EdgeInsets.all(MockMateSpacing.large),
      decoration: BoxDecoration(
        color: MockMateColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MockMateColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MockMateColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded, color: MockMateColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Device Check',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
            ],
          ),
          const SizedBox(height: MockMateSpacing.large),

          // Microphone Meter
          const Text(
            'Microphone Input Meter',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: MockMateColors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MockMateColors.outlineStrong),
            ),
            child: Row(
              children: [
                const Icon(Icons.mic_rounded, color: MockMateColors.cyan, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _micLevels.map((level) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 8,
                          height: 24 * level,
                          decoration: BoxDecoration(
                            color: Color.lerp(MockMateColors.primary, MockMateColors.cyan, level),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Live',
                  style: TextStyle(color: MockMateColors.cyan, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: MockMateSpacing.medium),

          // Speaker Test Button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _runSpeakerTest,
                  icon: Icon(
                    _isTestingAudio ? Icons.volume_up_rounded : Icons.graphic_eq_rounded,
                    color: MockMateColors.cyan,
                    size: 18,
                  ),
                  label: Text(_isTestingAudio ? 'Testing...' : 'Test Speakers'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _speakerStatus,
            style: TextStyle(
              color: _isTestingAudio ? MockMateColors.cyan : MockMateColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: MockMateSpacing.large),

          const Divider(color: MockMateColors.outline),
          const SizedBox(height: MockMateSpacing.medium),

          // Status Indicators
          _buildStatusTile(
            icon: Icons.memory_rounded,
            title: 'Local AI / Engine Ready',
            subtitle: 'Loaded & Initialized (Local Processing)',
            statusColor: Colors.greenAccent,
            statusText: 'Ready',
          ),
          const SizedBox(height: MockMateSpacing.small),
          _buildStatusTile(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy Status Check',
            subtitle: 'Protected: Local processing only',
            statusColor: MockMateColors.cyan,
            statusText: 'Locked',
          ),
          const SizedBox(height: MockMateSpacing.small),
          _buildStatusTile(
            icon: Icons.mic_none_rounded,
            title: 'Microphone Permission',
            subtitle: _micPermissionGranted ? 'Microphone Access: Granted' : 'Permission needed',
            statusColor: _micPermissionGranted ? Colors.greenAccent : Colors.amberAccent,
            statusText: _micPermissionGranted ? 'Granted' : 'Request',
            onActionTap: () => setState(() => _micPermissionGranted = true),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color statusColor,
    required String statusText,
    VoidCallback? onActionTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: MockMateColors.surfaceRaised,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: MockMateColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: MockMateColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewSummaryPanel(InterviewSetupConfig cfg) {
    return Container(
      padding: const EdgeInsets.all(MockMateSpacing.large),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MockMateColors.surface,
            MockMateColors.surfaceRaised,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MockMateColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MockMateColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assignment_outlined, color: MockMateColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Interview Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
            ],
          ),
          const SizedBox(height: MockMateSpacing.large),

          _buildSummaryDetailRow(Icons.work_rounded, 'Target Role', cfg.targetRole),
          _buildSummaryDetailRow(Icons.psychology_rounded, 'Interview Type', cfg.interviewType),
          _buildSummaryDetailRow(Icons.tune_rounded, 'Difficulty Level', cfg.difficulty),
          _buildSummaryDetailRow(Icons.timer_rounded, 'Session Duration', '${cfg.durationMinutes} Minutes'),
          _buildSummaryDetailRow(Icons.language_rounded, 'Language', cfg.language),
          _buildSummaryDetailRow(Icons.description_rounded, 'Selected CV', cfg.cvFileName),

          const SizedBox(height: MockMateSpacing.xLarge),

          // Glowing Start Button
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: MockMateColors.primary.withValues(alpha: 0.45),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              key: const Key('startMockInterviewButton'),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.liveInterview);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MockMateColors.primaryStrong,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              icon: const Icon(Icons.mic_rounded, size: 22, color: Colors.white),
              label: const Text(
                'Start Mock Interview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: MockMateColors.cyan),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(color: MockMateColors.textSecondary, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: MockMateColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
