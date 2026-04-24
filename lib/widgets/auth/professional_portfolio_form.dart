import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../common/text_field_widget.dart';

class ProfessionalPortfolioForm extends StatelessWidget {
  const ProfessionalPortfolioForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SHOWCASING YOUR HERITAGE",
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.primaryGold,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Professional Portfolio",
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 30),

        Text(
          "PROFESSIONAL MANIFESTO",
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        const CustomTextField(
          label: "Briefly describe your professional philosophy...",
          icon: Icons.auto_awesome_outlined,
          maxLines: 4, 
        ),
        const SizedBox(height: 30),

        Text(
          "SIGNATURE EVENTS (PORTFOLIO)",
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _buildImageUploadGrid(),
        const SizedBox(height: 30),

        Text(
          "STRATEGIC PARTNERS",
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        const CustomTextField(
          label: "Add partners (e.g. VOGUE, FERRARI)",
          icon: Icons.handshake_outlined,
        ),
        const SizedBox(height: 15),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPartnerTag("VOGUE ITALIA"),
            _buildPartnerTag("LVMH GROUP"),
            _buildPartnerTag("FERRARI S.P.A"),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUploadGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.buttonSubtle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryGold, size: 20),
        );
      },
    );
  }

 
  Widget _buildPartnerTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.greyText.withOpacity(0.8),
          fontSize: 9,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}