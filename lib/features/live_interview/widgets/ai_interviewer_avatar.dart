import 'package:flutter/material.dart';

class AiInterviewerAvatar extends StatelessWidget {
  const AiInterviewerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3), width: 2),
          ),
          child: const Icon(Icons.psychology_outlined, size: 70, color: Color(0xFF6366F1)),
        ),
        const SizedBox(height: 24),
        const Text(
          "MockMate AI Interviewer",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Listening to your response...",
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 35),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 5,
            height: (index % 2 == 0) ? 35.0 : 18.0,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(10),
            ),
          )),
        ),
      ],
    );
  }
}
