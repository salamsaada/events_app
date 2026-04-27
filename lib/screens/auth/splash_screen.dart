import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/screens/home/home_page.dart';
import 'package:eventsapp/screens/selection_screen.dart';
import 'package:flutter/material.dart';

class AppSpacing {
  static const double sm = 8;
  static const double lg = 24;
  static const double xl = 32;
  static const double radiusLarge = 24;
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    // Navigate after animation
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final token = CacheHelper().getData(key: ApiKey.token);
        if (token != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SelectionScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E14), Color(0xFF161B22)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Event emblem container
                  Container(
                    width: 136,
                    height: 136,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFF8ED), Color(0xFFFDE7D9)],
                      ),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusLarge + 8,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFE67E22,
                          ).withValues(alpha: 0.28),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Center(child: _buildEventIcon()),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // App Name
                  Text(
                    'Royal Events',
                    style: AppTextStyles.mainTitle.copyWith(
                      color: AppColors.whiteText,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Tagline
                  Text(
                    'The Legacy of Excellence',
                    style: AppTextStyles.bodyGrey.copyWith(
                      color: AppColors.whiteText.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventIcon() {
    return CustomPaint(size: const Size(88, 88), painter: EventIconPainter());
  }
}

class EventIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Outer badge
    paint.color = const Color(0xFFFFE2BE);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.1,
          size.width * 0.84,
          size.height * 0.8,
        ),
        const Radius.circular(22),
      ),
      paint,
    );

    // Calendar body
    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.2,
          size.height * 0.24,
          size.width * 0.6,
          size.height * 0.52,
        ),
        const Radius.circular(12),
      ),
      paint,
    );

    // Calendar top strip
    paint.color = const Color(0xFFE86A33);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.2,
          size.height * 0.24,
          size.width * 0.6,
          size.height * 0.14,
        ),
        const Radius.circular(12),
      ),
      paint,
    );

    // Calendar rings
    paint.color = const Color(0xFFB44A1F);
    canvas.drawCircle(
      Offset(size.width * 0.34, size.height * 0.24),
      size.width * 0.03,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.66, size.height * 0.24),
      size.width * 0.03,
      paint,
    );

    // Center star mark
    paint.color = const Color(0xFFE86A33);
    final star = Path()
      ..moveTo(size.width * 0.5, size.height * 0.45)
      ..lineTo(size.width * 0.54, size.height * 0.54)
      ..lineTo(size.width * 0.64, size.height * 0.55)
      ..lineTo(size.width * 0.57, size.height * 0.62)
      ..lineTo(size.width * 0.59, size.height * 0.72)
      ..lineTo(size.width * 0.5, size.height * 0.67)
      ..lineTo(size.width * 0.41, size.height * 0.72)
      ..lineTo(size.width * 0.43, size.height * 0.62)
      ..lineTo(size.width * 0.36, size.height * 0.55)
      ..lineTo(size.width * 0.46, size.height * 0.54)
      ..close();
    canvas.drawPath(star, paint);

    // Confetti dots
    paint.color = const Color(0xFFFFA94D);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.16),
      size.width * 0.018,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.79, size.height * 0.83),
      size.width * 0.02,
      paint,
    );
    paint.color = const Color(0xFFE86A33);
    canvas.drawCircle(
      Offset(size.width * 0.84, size.height * 0.2),
      size.width * 0.014,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.16, size.height * 0.8),
      size.width * 0.016,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
