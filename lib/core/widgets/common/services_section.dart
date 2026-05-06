import 'package:eventsapp/screens/booking_path_page.dart';
import 'package:eventsapp/screens/professional_Staff_Page.dart';
import 'package:eventsapp/screens/ready_made_packages_page.dart';
import 'package:eventsapp/screens/services_categories_page.dart';
import 'package:eventsapp/screens/wedding_halls_page.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

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
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'خدمات فاخرة',
                    style: AppTextStyles.mainTitle.copyWith(
                      color: AppColors.primaryGold,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'مختارة بعناية لذوقكم الرفيع.',
                    style: AppTextStyles.bodyGrey.copyWith(
                      color: AppColors.greyText,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
           _ServiceCard(
            icon: Icons.star,
            title: 'الخدمات الفردية',
            description: 'تنسيق الزهور، إضاءة مخصصة، وديكورات\nراقية.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServicesCategoriesPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
           _ServiceCard(
            icon: Icons.celebration,
            title: 'قاعات الأفراح',
            description: 'قصور تاريخية وتحف معمارية حديثة.',
 
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeddingHallsPage(
                    //categoryName: "Wedding Halls",
                  ),
                ),
              );
            }
          ),
          const SizedBox(height: 24),
           _ServiceCard(
            icon: Icons.people,
            title: 'الكادر المهني',
            description: 'خدمات النخبة، طهاة عالميون، ومخططون\nخبراء.',
            onTap: () {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  ProfessionalStaffPage(eventName: 'الكادر المهني'),
      ),
    );
  },
          ),
           const SizedBox(height: 24),

           _ServiceCard(
            icon: Icons.celebration,
            title: 'Ready-Made Packages',
            description: 'Complete party experiences with comprehensive planning and execution',
 
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadyMadePackagesPage(
                    categoryName: "Ready-Made Packages",
                  ),
                ),
              );
            }
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
  final VoidCallback onTap; 

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( 
      onTap: onTap,
      borderRadius: BorderRadius.circular(8), 
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(33),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                color: const Color(0xFF25282E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: AppColors.primaryGold, size: 24),
            ),
            const SizedBox(height: 17),
            Text(title, textAlign: TextAlign.right, style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMain.copyWith(color: AppColors.greyText, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}