import 'package:flutter/material.dart';
import 'models/user_profile_model.dart';
import 'widgets/profile_menu_item.dart';
import 'package:mockmate/features/cv_manager/cv_manager_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    final user = UserProfile(
      name: "Ereny",
      email: "alia.ereny@mockmate.ai",
      targetRole: "aim",
      careerField: "Software Engineering",
      experienceLevel: "Student",
      completedInterviews: 0,
      practiceTime: "0 min",
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
          
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Color(0xFF151922),
                          child: Icon(Icons.person, size: 45, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Target Role: ${user.targetRole}", style: const TextStyle(color: Colors.white54, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151922),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("Interviews", "${user.completedInterviews}"),
                  Container(width: 1, height: 30, color: Colors.white10),
                  _buildStatItem("Practice Time", user.practiceTime),
                ],
              ),
            ),
            const SizedBox(height: 24),

          
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF151922),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.badge_outlined,
                    title: "Setup Details (${user.careerField})",
                    onTap: () {},
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  ProfileMenuItem(
                    icon: Icons.description_outlined,
                    title: "Manage CV ",
                    onTap: () {
                     Navigator.push(
                        context,
                         MaterialPageRoute(
                         builder: (context) => CVManagerScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: "Account Settings",
                    onTap: () {},
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: "Sign Out",
                    isDestructive: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
      ],
    );
  }
}