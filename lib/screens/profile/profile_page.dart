import 'package:flutter/material.dart';

import '../home/home_page.dart';
import '../../core/widgets/common/bottom_navigation.dart';
import '../settings/settings_page.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  const Text('الملف الشخصي', style: AppTextStyles.mainTitle),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryGold.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'سارة الحربي',
                            style: AppTextStyles.subtitle,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'عميل مميز - Elite',
                            style: AppTextStyles.bodyMain.copyWith(
                              color: AppColors.primaryGold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'sarah@royal-events.com',
                            style: AppTextStyles.tileCaption.copyWith(
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage('https://picsum.photos/800/600'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _ProfileInfoCard(
                title: 'معلومات الحساب',
                rows: [
                  _InfoRowData('رقم الجوال', '+966 55 555 5555'),
                  _InfoRowData('المدينة', 'الرياض'),
                  _InfoRowData('نوع الفعاليات', 'أفراح - شركات - مناسبات خاصة'),
                ],
              ),
              const SizedBox(height: 16),
              const _ProfileInfoCard(
                title: 'الاشتراك والعضوية',
                rows: [
                  _InfoRowData('الخطة الحالية', 'Royal Membership'),
                  _InfoRowData('تاريخ التجديد', '15 مايو 2026'),
                  _InfoRowData('الرصيد الحالي', '4,800 ريال'),
                ],
              ),
              const SizedBox(height: 16),
              const _ProfileInfoCard(
                title: 'العناوين المحفوظة',
                rows: [
                  _InfoRowData('المنزل', 'حي الياسمين، الرياض'),
                  _InfoRowData('العمل', 'طريق الملك فهد، الرياض'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: 3,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRowData> rows;

  const _ProfileInfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      row.value,
                      style: AppTextStyles.tileCaption.copyWith(
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    row.label,
                    style: AppTextStyles.tileTitle.copyWith(
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRowData {
  final String label;
  final String value;

  const _InfoRowData(this.label, this.value);
}
