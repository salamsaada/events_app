import 'package:flutter/material.dart';

import '../home/home_page.dart';
import '../../core/widgets/common/bottom_navigation.dart';

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
      backgroundColor: const Color(0xFF080808),
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
                      color: Color(0xFFF9C54D),
                    ),
                  ),
                  const Text(
                    'الإعدادات',
                    style: TextStyle(
                      color: Color(0xFFF9C54D),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SettingsSection(
                title: 'الحساب',
                children: const [
                  _ActionTile(
                    icon: Icons.person_outline,
                    title: 'تعديل الملف الشخصي',
                  ),
                  _ActionTile(
                    icon: Icons.credit_card_outlined,
                    title: 'طرق الدفع',
                  ),
                  _ActionTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'طلباتي السابقة',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: 'الإشعارات',
                children: [
                  _SwitchTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'إشعارات التطبيق',
                    value: pushNotifications,
                    onChanged: (value) =>
                        setState(() => pushNotifications = value),
                  ),
                  _SwitchTile(
                    icon: Icons.sms_outlined,
                    title: 'الرسائل النصية',
                    value: smsNotifications,
                    onChanged: (value) =>
                        setState(() => smsNotifications = value),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: 'التفضيلات',
                children: [
                  _SwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'الوضع الليلي',
                    value: darkMode,
                    onChanged: (value) => setState(() => darkMode = value),
                  ),
                  const _ActionTile(
                    icon: Icons.language_outlined,
                    title: 'اللغة: العربية',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: 'الأمان',
                children: [
                  _SwitchTile(
                    icon: Icons.fingerprint,
                    title: 'الدخول بالبصمة',
                    value: biometric,
                    onChanged: (value) => setState(() => biometric = value),
                  ),
                  const _ActionTile(
                    icon: Icons.lock_outline,
                    title: 'تغيير كلمة المرور',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF87171),
                    side: const BorderSide(color: Color(0xFF7F1D1D)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('تسجيل الخروج'),
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
        color: const Color(0xFF1A1C21),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
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
      leading: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Color(0xFFE5E7EB), fontSize: 14),
      ),
      trailing: Icon(icon, color: const Color(0xFFF9C54D), size: 20),
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
        activeColor: const Color(0xFFF9C54D),
      ),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Color(0xFFE5E7EB), fontSize: 14),
      ),
      trailing: Icon(icon, color: const Color(0xFFF9C54D), size: 20),
    );
  }
}
