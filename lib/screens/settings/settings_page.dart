import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_page.dart';
import '../../core/widgets/common/bottom_navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;
  bool smsNotifications = false;
  bool darkMode = true;
  bool biometric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.settingsTitle,
                    style: AppTextStyles.mainTitle,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SettingsSection(
                title: AppLocalizations.of(context)!.account,
                children: [
                  _ActionTile(
                    icon: Icons.person_outline,
                    title: AppLocalizations.of(context)!.editProfile,
                  ),
                  _ActionTile(
                    icon: Icons.credit_card_outlined,
                    title: AppLocalizations.of(context)!.paymentMethods,
                  ),
                  _ActionTile(
                    icon: Icons.shopping_bag_outlined,
                    title: AppLocalizations.of(context)!.previousOrders,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: AppLocalizations.of(context)!.notifications,
                children: [
                  _SwitchTile(
                    icon: Icons.notifications_active_outlined,
                    title: AppLocalizations.of(context)!.pushNotifications,
                    value: pushNotifications,
                    onChanged: (value) =>
                        setState(() => pushNotifications = value),
                  ),
                  _SwitchTile(
                    icon: Icons.sms_outlined,
                    title: AppLocalizations.of(context)!.smsNotifications,
                    value: smsNotifications,
                    onChanged: (value) =>
                        setState(() => smsNotifications = value),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: AppLocalizations.of(context)!.preferences,
                children: [
                  _SwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: AppLocalizations.of(context)!.nightMode,
                    value: context.watch<ThemeCubit>().isDark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                  _LanguageTile(
                    icon: Icons.language_outlined,
                    currentLanguage: context
                        .watch<LanguageCubit>()
                        .languageCode,
                    onChanged: (language) {
                      context.read<LanguageCubit>().setLanguage(language);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: AppLocalizations.of(context)!.security,
                children: [
                  _SwitchTile(
                    icon: Icons.fingerprint,
                    title: AppLocalizations.of(context)!.biometric,
                    value: biometric,
                    onChanged: (value) => setState(() => biometric = value),
                  ),
                  _ActionTile(
                    icon: Icons.lock_outline,
                    title: AppLocalizations.of(context)!.changePassword,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorRed,
                    side: const BorderSide(color: AppColors.errorDarkRed),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: Text(AppLocalizations.of(context)!.logout),
                ),
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ActionTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: const Icon(Icons.chevron_right, color: AppColors.darkGrey),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: AppTextStyles.tileTitle,
      ),
      trailing: Icon(icon, color: AppColors.primaryGold, size: 20),
      onTap: () {},
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryGold,
      ),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: AppTextStyles.tileTitle,
      ),
      trailing: Icon(icon, color: AppColors.primaryGold, size: 20),
      onTap: () {},
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final IconData icon;
  final String currentLanguage;
  final ValueChanged<String> onChanged;

  const _LanguageTile({
    required this.icon,
    required this.currentLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: PopupMenuButton<String>(
        onSelected: onChanged,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'ar', child: Text('العربية')),
          const PopupMenuItem<String>(value: 'en', child: Text('English')),
        ],
        child: Icon(Icons.chevron_right, color: AppColors.darkGrey),
      ),
      title: Text(
        l10n.language,
        textAlign: TextAlign.right,
        style: AppTextStyles.tileTitle,
      ),
      trailing: Icon(icon, color: AppColors.primaryGold, size: 20),
    );
  }
}
