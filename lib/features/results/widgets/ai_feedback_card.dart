import 'package:flutter/material.dart';

class AiFeedbackCard extends StatelessWidget {
  final List<String> recommendations;

  const AiFeedbackCard({Key? key, required this.recommendations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFFBBF24), size: 20),
              SizedBox(width: 8),
              Text(
                "AI Recommendations",
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recommendations.map((text) => _buildFeedbackBullet(text)),
        ],
      ),
    );
  }

  Widget _buildFeedbackBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Color(0xFF6366F1), fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}