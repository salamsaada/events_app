import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../generated/app_localizations.dart';
import '../settings/settings_page.dart';
import '../../core/widgets/common/bottom_navigation.dart';
import '../../models/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Fetch user data automatically when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getUserProfile();
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            );
          }
          if (state is ProfileLoaded) {
            return _buildProfileView(context, l10n, state.user);
          }
          if (state is AuthFailure) {
            return Center(child: Text(state.errorMessage));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: 3,
        onItemSelected: (index) {},
      ),
    );
  }

  Widget _buildProfileView(
    BuildContext context,
    AppLocalizations l10n,
    UserModel user,
  ) {
    // Logic: Display phone number if available, otherwise fallback to email
    final String contactInfo = (user.phone != null && user.phone!.isNotEmpty)
        ? user.phone!
        : user.email;
    final String contactLabel = (user.phone != null && user.phone!.isNotEmpty)
        ? l10n.phone
        : l10n.emailAddress;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  ),
                  icon: const Icon(
                    Icons.settings,
                    color: AppColors.primaryGold,
                  ),
                ),
                Text(l10n.profileTitle, style: AppTextStyles.mainTitle),
              ],
            ),
            const SizedBox(height: 30),

            // Profile Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.primaryGold,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.firstName} ${user.lastName}",
                          style: AppTextStyles.mainTitle.copyWith(fontSize: 20),
                        ),
                        Text(contactInfo, style: AppTextStyles.tileCaption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account Information Card
            _ProfileInfoCard(
              title: l10n.accountInfo,
              rows: [_InfoRowData(contactLabel, contactInfo)],
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable card widget for profile information
class _ProfileInfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRowData> rows;
  const _ProfileInfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.primaryGold,
              fontSize: 16,
            ),
          ),
          const Divider(height: 24),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    row.value,
                    style: AppTextStyles.tileCaption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    row.label,
                    style: AppTextStyles.tileTitle.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
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
