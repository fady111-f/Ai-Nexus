import 'package:flutter/material.dart';

class RecordingIndicator extends StatelessWidget {
  final bool isRecording;
  final String durationText;

  const RecordingIndicator({
    Key? key,
    required this.isRecording,
    this.durationText = "01:24",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isRecording ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
            const SizedBox(width: 6),
            Text(
              "REC $durationText",
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}