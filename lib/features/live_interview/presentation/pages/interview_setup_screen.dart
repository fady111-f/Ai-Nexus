import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class InterviewSetupConfig {
  const InterviewSetupConfig({
    this.cvChoice = 'Select Existing',
    this.cvFileName = 'Software_Engineer_CV.pdf',
    this.targetJobMode = 'Manual Role',
    this.targetRole = 'Senior Flutter Developer',
    this.jobDescription = '',
    this.interviewType = 'Technical',
    this.difficulty = 'Realistic',
    this.durationMinutes = 10,
    this.language = 'Tech-Arabish',
  });

  final String cvChoice;
  final String cvFileName;
  final String targetJobMode;
  final String targetRole;
  final String jobDescription;
  final String interviewType;
  final String difficulty;
  final int durationMinutes;
  final String language;
}

class InterviewSetupScreen extends StatefulWidget {
  const InterviewSetupScreen({super.key});

  @override
  State<InterviewSetupScreen> createState() => _InterviewSetupScreenState();
}

class _InterviewSetupScreenState extends State<InterviewSetupScreen> {
  String _selectedCvChoice = 'Select Existing';
  String _selectedCvFileName = 'Software_Engineer_CV.pdf';
  String _selectedTargetJobMode = 'Manual Role';
  final TextEditingController _roleController =
      TextEditingController(text: 'Senior Flutter Developer');
  final TextEditingController _jdController = TextEditingController();
  String _selectedType = 'Technical';
  String _selectedDifficulty = 'Realistic';
  int _selectedDuration = 10;
  String _selectedLanguage = 'Tech-Arabish';

  @override
  void dispose() {
    _roleController.dispose();
    _jdController.dispose();
    super.dispose();
  }

  void _proceedToLobby() {
    final config = InterviewSetupConfig(
      cvChoice: _selectedCvChoice,
      cvFileName: _selectedCvFileName,
      targetJobMode: _selectedTargetJobMode,
      targetRole: _roleController.text.trim().isEmpty
          ? 'Software Engineer'
          : _roleController.text.trim(),
      jobDescription: _jdController.text.trim(),
      interviewType: _selectedType,
      difficulty: _selectedDifficulty,
      durationMinutes: _selectedDuration,
      language: _selectedLanguage,
    );

    Navigator.of(context).pushNamed(
      AppRoutes.lobby,
      arguments: config,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Interview Setup', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MockMateSpacing.large),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Configure Your Practice Session',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Personalize the AI interviewer behavior, role context, and test parameters.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: MockMateSpacing.large),

                  // Step 1: Choose CV
                  _buildSectionHeader('1. Choose CV', Icons.description_outlined),
                  const SizedBox(height: MockMateSpacing.small),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceCard(
                          title: 'Select Existing',
                          subtitle: _selectedCvFileName,
                          icon: Icons.folder_open_rounded,
                          isSelected: _selectedCvChoice == 'Select Existing',
                          onTap: () => setState(() => _selectedCvChoice = 'Select Existing'),
                        ),
                      ),
                      const SizedBox(width: MockMateSpacing.medium),
                      Expanded(
                        child: _ChoiceCard(
                          title: 'Upload PDF',
                          subtitle: 'Upload a new resume',
                          icon: Icons.upload_file_rounded,
                          isSelected: _selectedCvChoice == 'Upload PDF',
                          onTap: () => setState(() {
                            _selectedCvChoice = 'Upload PDF';
                            _selectedCvFileName = 'Uploaded_Resume.pdf';
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MockMateSpacing.large),

                  // Step 2: Target Job
                  _buildSectionHeader('2. Target Job', Icons.work_outline_rounded),
                  const SizedBox(height: MockMateSpacing.small),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceCard(
                          title: 'Manual Role',
                          subtitle: 'Enter target title',
                          icon: Icons.badge_outlined,
                          isSelected: _selectedTargetJobMode == 'Manual Role',
                          onTap: () => setState(() => _selectedTargetJobMode = 'Manual Role'),
                        ),
                      ),
                      const SizedBox(width: MockMateSpacing.medium),
                      Expanded(
                        child: _ChoiceCard(
                          title: 'Paste JD',
                          subtitle: 'Paste Job Description',
                          icon: Icons.paste_rounded,
                          isSelected: _selectedTargetJobMode == 'Paste JD',
                          onTap: () => setState(() => _selectedTargetJobMode = 'Paste JD'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MockMateSpacing.medium),
                  if (_selectedTargetJobMode == 'Manual Role')
                    TextField(
                      controller: _roleController,
                      decoration: const InputDecoration(
                        labelText: 'Target Job Title',
                        hintText: 'e.g. Senior Mobile Engineer',
                        prefixIcon: Icon(Icons.title_rounded),
                      ),
                    )
                  else
                    TextField(
                      controller: _jdController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Job Description Text',
                        hintText: 'Paste key requirements, stack, and responsibilities...',
                        prefixIcon: Icon(Icons.notes_rounded),
                      ),
                    ),
                  const SizedBox(height: MockMateSpacing.large),

                  // Step 3: Type
                  _buildSectionHeader('3. Interview Type', Icons.psychology_outlined),
                  const SizedBox(height: MockMateSpacing.small),
                  Wrap(
                    spacing: MockMateSpacing.small,
                    runSpacing: MockMateSpacing.small,
                    children: ['HR', 'Technical', 'Behavioral', 'Mixed'].map((type) {
                      final isSelected = _selectedType == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: MockMateColors.primary,
                        backgroundColor: MockMateColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : MockMateColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => setState(() => _selectedType = type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: MockMateSpacing.large),

                  // Step 4: Difficulty
                  _buildSectionHeader('4. Difficulty', Icons.tune_rounded),
                  const SizedBox(height: MockMateSpacing.small),
                  Row(
                    children: ['Friendly', 'Realistic', 'Tough'].map((diff) {
                      final isSelected = _selectedDifficulty == diff;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _ChoiceCard(
                            title: diff,
                            subtitle: diff == 'Friendly'
                                ? 'Encouraging'
                                : diff == 'Realistic'
                                    ? 'Standard hiring bar'
                                    : 'Stress test',
                            icon: diff == 'Friendly'
                                ? Icons.sentiment_satisfied_alt_rounded
                                : diff == 'Realistic'
                                    ? Icons.balance_rounded
                                    : Icons.local_fire_department_rounded,
                            isSelected: isSelected,
                            onTap: () => setState(() => _selectedDifficulty = diff),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: MockMateSpacing.large),

                  // Step 5: Duration
                  _buildSectionHeader('5. Duration', Icons.timer_outlined),
                  const SizedBox(height: MockMateSpacing.small),
                  Row(
                    children: [5, 10, 20].map((mins) {
                      final isSelected = _selectedDuration == mins;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _ChoiceCard(
                            title: '$mins min',
                            subtitle: mins == 5
                                ? 'Quick Warm-up'
                                : mins == 10
                                    ? 'Standard Round'
                                    : 'Deep Dive',
                            icon: Icons.hourglass_bottom_rounded,
                            isSelected: isSelected,
                            onTap: () => setState(() => _selectedDuration = mins),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: MockMateSpacing.large),

                  // Step 6: Language
                  _buildSectionHeader('6. Language', Icons.translate_rounded),
                  const SizedBox(height: MockMateSpacing.small),
                  Row(
                    children: ['English', 'Arabic', 'Tech-Arabish'].map((lang) {
                      final isSelected = _selectedLanguage == lang;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _ChoiceCard(
                            title: lang,
                            subtitle: lang == 'English'
                                ? 'Full English'
                                : lang == 'Arabic'
                                    ? 'الفصحى / العامية'
                                    : 'English Tech + Arabic',
                            icon: Icons.language_rounded,
                            isSelected: isSelected,
                            onTap: () => setState(() => _selectedLanguage = lang),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: MockMateSpacing.xxLarge),

                  // Submit button
                  ElevatedButton.icon(
                    key: const Key('startLiveInterviewButton'),
                    onPressed: _proceedToLobby,
                    icon: const Icon(Icons.play_arrow_rounded, size: 24),
                    label: const Text(
                      'Start Live Interview',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: MockMateSpacing.large),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: MockMateColors.cyan),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? MockMateColors.primary.withValues(alpha: 0.18)
          : MockMateColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(MockMateSpacing.medium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? MockMateColors.primary
                  : MockMateColors.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? MockMateColors.primary : MockMateColors.textSecondary,
                size: 22,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: MockMateColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: MockMateColors.textSecondary,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
