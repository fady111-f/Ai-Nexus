import 'package:flutter/material.dart';

class UploadCVButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isUploading;

  const UploadCVButton({
    Key? key,
    required this.onPressed,
    this.isUploading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: isUploading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          disabledBackgroundColor: const Color(0xFF6366F1).withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        icon: isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.upload_file, color: Colors.white),
        label: Text(
          isUploading ? "Analyzing CV with AI..." : "Upload New CV",
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}