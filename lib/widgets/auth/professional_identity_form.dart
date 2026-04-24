import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/widgets/common/text_field_widget.dart';
import 'package:flutter/material.dart';

class ProfessionalIdentityForm extends StatelessWidget {
  const ProfessionalIdentityForm({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CREATING YOUR LEGACY",
          style: AppTextStyles.goldSubtitle,
        ),
        const SizedBox(height: 8),
        Text(
          "Professional Identity",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 30),

        // منطقة الصورة الشخصية
        Center(
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white10),
                  color: AppColors.cardBackground.withOpacity(0.5),
                ),
                child: const Icon(Icons.person_outline, size: 50, color: Colors.white24),
              ),
              Positioned(
                bottom: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.primaryColor, 
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        const CustomTextField(
          label: "Full Name",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),

        const CustomTextField(
          label: "Professional Title (e.g. Executive Curator)",
          icon: Icons.workspace_premium_outlined,
        ),
        const SizedBox(height: 20),

        const CustomTextField(
          label: "Primary Contact / Phone",
          icon: Icons.phone_outlined,
        ),
        const SizedBox(height: 30),

        // قسم المؤهلات
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "DISTINGUISHED QUALIFICATIONS",
              style: AppTextStyles.captionBold.copyWith(color: Colors.white70),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "+ ADD", 
                style: AppTextStyles.captionBold.copyWith(color: theme.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        _buildQualificationCard(
          context,
          "Master of Ceremonial Logistics",
          "SDA Bocconi School of Management",
          Icons.military_tech_outlined,
        ),
      ],
    );
  }

  Widget _buildQualificationCard(BuildContext context, String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: AppTextStyles.bodyGrey.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}