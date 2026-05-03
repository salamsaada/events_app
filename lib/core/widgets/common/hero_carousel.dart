import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../generated/app_localizations.dart';

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
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
          ),
          image: const DecorationImage(
            image: NetworkImage('https://picsum.photos/800/600'),
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
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.featuredHall,
                      style: const TextStyle(
                        color: Color(0xFF261A00),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.goldSuite,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.hallDescription,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFFD2C5AF),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.bookRequest,
                      style: const TextStyle(
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
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 4,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 32, height: 4, color: AppColors.primaryGold),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
