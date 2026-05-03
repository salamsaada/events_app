import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../generated/app_localizations.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primaryGold.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: const TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.luxuryServices,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mainTitle.copyWith(
                        color: AppColors.primaryGold,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.selectedCarefully,
                      style: AppTextStyles.bodyGrey.copyWith(
                        color: AppColors.greyText,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _ServiceCard(
            icon: Icons.star,
            title: AppLocalizations.of(context)!.individualServices,
            description: AppLocalizations.of(context)!.flowerArrangement,
          ),
          const SizedBox(height: 24),
          _ServiceCard(
            icon: Icons.celebration,
            title: AppLocalizations.of(context)!.weddingHalls,
            description: AppLocalizations.of(context)!.historicalPalaces,
          ),
          const SizedBox(height: 24),
          _ServiceCard(
            icon: Icons.people,
            title: AppLocalizations.of(context)!.professionalStaff,
            description: AppLocalizations.of(context)!.serviceDescription,
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(33),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF25282E)
                  : const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: AppColors.primaryGold, size: 24),
          ),
          const SizedBox(height: 17),
          Text(
            title,
            textAlign: TextAlign.right,
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMain.copyWith(
              color: AppColors.greyText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
