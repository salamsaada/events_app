import 'package:flutter/material.dart';

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
                        color: const Color(0xFFF9C54D).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: Color(0xFFF9C54D),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'خدمات فاخرة',
                    style: TextStyle(
                      color: Color(0xFFF9C54D),
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'مختارة بعناية لذوقكم الرفيع.',
                    style: TextStyle(color: Color(0xFF737373), fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const _ServiceCard(
            icon: Icons.star,
            title: 'الخدمات الفردية',
            description: 'تنسيق الزهور، إضاءة مخصصة، وديكورات\nراقية.',
          ),
          const SizedBox(height: 24),
          const _ServiceCard(
            icon: Icons.celebration,
            title: 'قاعات الأفراح',
            description: 'قصور تاريخية وتحف معمارية حديثة.',
          ),
          const SizedBox(height: 24),
          const _ServiceCard(
            icon: Icons.people,
            title: 'الكادر المهني',
            description: 'خدمات النخبة، طهاة عالميون، ومخططون\nخبراء.',
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
        color: const Color(0xFF1A1C21),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFF9C54D).withOpacity(0.05),
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
            child: Icon(icon, color: const Color(0xFFF9C54D), size: 24),
          ),
          const SizedBox(height: 17),
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF737373),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
