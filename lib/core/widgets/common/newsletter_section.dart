import 'package:flutter/material.dart';

class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFFF9C54D).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'عضوية النخبة',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'انضم إلى دائرتنا الملكية للحصول على أولوية الحجز\nوالوصول الحصري للقاعات.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF737373),
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1C21),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0xFF333333)),
              ),
              child: const TextField(
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'بريدك الإلكتروني للعمل',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9C54D),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: const Text(
                'قدم الآن',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
