import 'package:flutter/material.dart';
import 'models/cv_model.dart';
import 'widgets/empty_cv_widget.dart';
import 'widgets/upload_cv_button.dart';
import 'widgets/cv_card.dart';
import 'package:file_picker/file_picker.dart';

class CVManagerScreen extends StatefulWidget {
  const CVManagerScreen({super.key});

  @override
  State<CVManagerScreen> createState() => _CVManagerScreenState();
}

class _CVManagerScreenState extends State<CVManagerScreen> {
  CVModel? _currentCV;
  bool _isUploading = false;

  void _handleUpload() async {
    try {
        
        FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() => _isUploading = true);

        // محاكاة وقت التحليل بالـ AI لمدة ثانيتين
        await Future.delayed(const Duration(seconds: 2));

        PlatformFile file = result.files.first;

        // حساب الحجم بالميجابايت
        String sizeInMb = "${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB";

        setState(() {
          _currentCV = CVModel(
            fileName: file.name,
            fileSize: sizeInMb,
            uploadDate: "Today",
            atsScore: 85,
            strengths: [
              "Strong keywords matching Software Engineering roles.",
              "Clear contact information and education structure."
            ],
            improvements: [
              "Consider adding a link to your GitHub profile.",
            ],
          );
          _isUploading = false;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  void _handleDelete() {
    setState(() => _currentCV = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("CV / Resume Manager", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentCV == null)
              const EmptyCVWidget()
            else
              CVCard(cv: _currentCV!, onDelete: _handleDelete),

            const SizedBox(height: 24),

            UploadCVButton(
              onPressed: _handleUpload,
              isUploading: _isUploading, 
            ),

            if (_currentCV != null) ...[
              const SizedBox(height: 35),
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFFFBBF24), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "AI Resume Insights",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              const Text("Strengths", style: TextStyle(color: Color(0xFF34D399), fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._currentCV!.strengths.map((s) => _buildInsightTile(s, Icons.check_circle_outline, const Color(0xFF34D399))),
              
              const SizedBox(height: 16),
              const Text("Suggested Improvements", style: TextStyle(color: Color(0xFFFBBF24), fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._currentCV!.improvements.map((i) => _buildInsightTile(i, Icons.lightbulb_outline, const Color(0xFFFBBF24))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsightTile(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
