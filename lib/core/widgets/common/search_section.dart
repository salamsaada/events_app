import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 342,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C21),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search, color: Color(0xFF737373), size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'ابحث عن القاعات، الكادر، أو المخططين...',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                  fontFamily: 'NotoSansArabic',
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
