import 'package:flutter/material.dart';

class InterviewControlBar extends StatelessWidget {
  final bool isMuted;
  final bool isRecording;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleRecord;
  final VoidCallback onEndCall;

  const InterviewControlBar({
    Key? key,
    required this.isMuted,
    required this.isRecording,
    required this.onToggleMic,
    required this.onToggleRecord,
    required this.onEndCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRoundButton(
          icon: isMuted ? Icons.mic_off : Icons.mic,
          color: isMuted ? Colors.redAccent : const Color(0xFF151922),
          onTap: onToggleMic,
        ),
        _buildRoundButton(
          icon: isRecording ? Icons.stop : Icons.radio_button_checked,
          color: isRecording ? Colors.redAccent : const Color(0xFF6366F1),
          onTap: onToggleRecord,
        ),
        _buildRoundButton(
          icon: Icons.call_end,
          color: Colors.red,
          onTap: onEndCall,
        ),
      ],
    );
  }

  Widget _buildRoundButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}