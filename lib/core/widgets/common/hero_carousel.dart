import 'package:flutter/material.dart';

class HeroCarousel extends StatelessWidget {
  const HeroCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 342,
        height: 480,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
          image: const DecorationImage(
            image: NetworkImage(
              'https://picsum.photos/800/600',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 40,
              right: 40,
              left: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9C54D),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'القاعة المميزة',
                      style: TextStyle(
                        color: Color(0xFF261A00),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'الجناح الذهبي',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'استمتع بالفخامة المعمارية وخدمات\nالكونسيرج المصممة خصيصًا لفعاليتك\nالقادمة رفيعة المستوى.',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFFD2C5AF),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9C54D),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'طلب حجز',
                      style: TextStyle(
                        color: Color(0xFF261A00),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 40,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 4,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 4,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 4,
                    color: const Color(0xFFF9C54D),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
