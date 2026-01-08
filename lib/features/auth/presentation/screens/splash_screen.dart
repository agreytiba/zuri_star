import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Check auth after animation
    Future.delayed(const Duration(milliseconds: 3000), () {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    await ref.read(authProvider.notifier).checkAuthStatus();
    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom yellow color from the design
    const backgroundColor = Color(0xFFEAB308); 

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Transform.rotate(
                    angle: _logoRotate.value * math.pi,
                    child: CustomPaint(
                      size: const Size(100, 100),
                      painter: LogoPainter(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Text(
                  'Zuristar',
                  style: GoogleFonts.outfit(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final path = Path();
    // Start top
    path.moveTo(w / 2, 0);
    
    // Curve to Right
    path.quadraticBezierTo(
      w / 2, h / 2 - 10, // Control point roughly center but offset
      w, h / 2,
    );

    // Curve to Bottom
    path.quadraticBezierTo(
      w / 2, h * 0.5 + 10,
      w / 2, h,
    );

    // Curve to Left
    path.quadraticBezierTo(
      w / 2, h / 2 + 10,
      0, h / 2,
    );

    // Curve to Top
    path.quadraticBezierTo(
      w / 2, h / 2 - 10,
      w / 2, 0,
    );

    path.close();

    // Draw the main shape
    canvas.drawPath(path, paint);

    // Draw the center hole (yellow square/diamond to match background)
    final holePaint = Paint()
      ..color = const Color(0xFFEAB308) // Match background
      ..style = PaintingStyle.fill;

    final holeSize = w * 0.25;
    final holeRect = Rect.fromCenter(
      center: center,
      width: holeSize,
      height: holeSize,
    );
    
    // Draw rotated rounded rect for the center "hole"
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: holeSize, height: holeSize),
        const Radius.circular(4),
      ),
      holePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
