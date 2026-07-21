import 'package:flutter/material.dart';

class LiveInterviewScreen extends StatefulWidget {
  const LiveInterviewScreen({super.key});

  @override
  State<LiveInterviewScreen> createState() => _LiveInterviewScreenState();
}

class _LiveInterviewScreenState extends State<LiveInterviewScreen> {
  bool _isRecording = false;
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Stack(
          children: [
           
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    ),
                    child: const Icon(Icons.face, size: 60, color: Color(0xFF6366F1)),
                  ),
                  const SizedBox(height: 24),
                  const Text("MockMate AI AI-Interviewer", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Listening to your response...", style: TextStyle(color: Colors.white54, fontSize: 14)),
                  
                  
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 6,
                      height: (index % 2 == 0) ? 40.0 : 20.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                  )
                ],
              ),
            ),

          
            Positioned(
              top: 20,
              left: 20,
              child: AnimatedOpacity(
                opacity: _isRecording ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(Icons.fiber_manual_record, color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text("REC 01:24", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),

            
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRoundButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    color: _isMuted ? Colors.redAccent : const Color(0xFF151922),
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                
                  _buildRoundButton(
                    icon: _isRecording ? Icons.stop : Icons.radio_button_checked,
                    color: _isRecording ? Colors.redAccent : const Color(0xFF6366F1),
                    onTap: () {
                      setState(() => _isRecording = !_isRecording);
                    },
                  ),
                  _buildRoundButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}
