import "dart:math";
import "package:flutter/material.dart";

class WaveRoute<T> extends PageRouteBuilder<T> {
  WaveRoute({
    required this.page,
    this.durationMs = 700, // slightly dreamy
  }) : super(
          transitionDuration: Duration(milliseconds: durationMs),
          reverseTransitionDuration:
              Duration(milliseconds: (durationMs * 0.85).round()),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubicEmphasized,
              reverseCurve: Curves.easeInOutCubic,
            );

            return Stack(
              children: [
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                  child: child,
                ),
                AnimatedBuilder(
                  animation: curved,
                  builder: (context, _) {
                    return ClipPath(
                      clipper: _WaveClipper(progress: curved.value),
                      child: child,
                    );
                  },
                ),
              ],
            );
          },
        );

  final Widget page;
  final int durationMs;
}

class _WaveClipper extends CustomClipper<Path> {
  _WaveClipper({required this.progress});

  final double progress;

  @override
  Path getClip(Size size) {
    final revealWidth = size.width * progress;

    final waveHeight = lerpDouble(70, 10, progress);
    final waveLength = lerpDouble(240, 120, progress);

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(revealWidth, 0);

    const steps = 9;
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final y = size.height * t;

      final wobble = sin((t * pi * 2) + (progress * pi)) * waveHeight;
      final x = revealWidth + wobble + sin(t * pi * 4) * (waveLength * 0.04);

      if (i == 0) {
        path.lineTo(x, y);
      } else {
        path.quadraticBezierTo(
          revealWidth,
          y - (size.height / steps) * 0.5,
          x,
          y,
        );
      }
    }

    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  double lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
