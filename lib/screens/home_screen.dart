import "dart:async";
import "package:flutter/material.dart";
import "../widgets/feature_tile.dart";
import "../widgets/wave_route.dart";
import "dates_screen.dart";
import "expenses_screen.dart";
import "explore_screen.dart";
import "notes_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _showIntro = true;
  bool _showPlane = false;
  bool _typingDone = false;

  static const Color sageOverlay = Color(0xFF7FBF9A);

  late final AnimationController _planeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  );

  late final Animation<double> _planeX = CurvedAnimation(
    parent: _planeCtrl,
    curve: Curves.easeInOutCubic,
  );

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(WaveRoute(page: page));
  }

  @override
  void dispose() {
    _planeCtrl.dispose();
    super.dispose();
  }

  Future<void> _startPlanningSequence() async {
    if (!_typingDone) return;

    setState(() => _showPlane = true);
    _planeCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 1100));

    if (!mounted) return;
    setState(() {
      _showPlane = false;
      _showIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // OPTIONAL: abstract blobs behind dashboard too (comment this out if you only want welcome screen)
            if (!_showIntro)
              Positioned.fill(
                child: CustomPaint(
                  painter: _AbstractBlobsPainter(
                    // slightly lighter for dashboard
                    opacity: 0.20,
                    primary: cs.primary,
                    secondary: cs.secondary,
                    accent: cs.tertiary,
                  ),
                ),
              ),

            // MAIN CONTENT (hidden until intro finishes)
            if (!_showIntro)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: cs.primary.withOpacity(0.25)),
                          ),
                          child: Icon(Icons.travel_explore, color: cs.primary),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Trip Dashboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.05,
                        children: [
                          FeatureTile(
                            title: "Dates",
                            subtitle: "Calendar + plans",
                            icon: Icons.calendar_month,
                            imageAssetPath: null, // add later
                            onTap: () => _open(context, const DatesScreen()),
                          ),
                          FeatureTile(
                            title: "Expenses",
                            subtitle: "Budget tracker",
                            icon: Icons.receipt_long,
                            imageAssetPath: null,
                            onTap: () => _open(context, const ExpensesScreen()),
                          ),
                          FeatureTile(
                            title: "Explore",
                            subtitle: "Hotels + rides",
                            icon: Icons.map_outlined,
                            imageAssetPath: null,
                            onTap: () => _open(context, const ExploreScreen()),
                          ),
                          FeatureTile(
                            title: "Notes",
                            subtitle: "Packing list",
                            icon: Icons.checklist,
                            imageAssetPath: null,
                            onTap: () => _open(context, const NotesScreen()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // INTRO OVERLAY with abstract blobs
            if (_showIntro)
              Positioned.fill(
                child: Stack(
                  children: [
                    // Abstract blob background behind the welcome card
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _AbstractBlobsPainter(
                          opacity: 0.30,
                          primary: cs.primary,
                          secondary: cs.secondary,
                          accent: cs.tertiary,
                        ),
                      ),
                    ),
                    // Soft tint layer (keeps blobs subtle)
                    Positioned.fill(
                      child: Container(color: sageOverlay.withOpacity(0.22)),
                    ),

                    Center(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.94),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                              color: cs.primary.withOpacity(0.55), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 26,
                              offset: const Offset(0, 18),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map_rounded,
                                size: 44, color: cs.primary),
                            const SizedBox(height: 14),
                            _TypewriterText(
                              text: "Welcome to your personal travel planner!",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                              speedMs: 28,
                              onFinished: () =>
                                  setState(() => _typingDone = true),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF7FBF9A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed:
                                    _typingDone ? _startPlanningSequence : null,
                                child: Text(
                                  _typingDone ? "Start Planning" : "Loading...",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ✈️ Plane animation layer
            if (_showPlane)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _planeX,
                    builder: (context, _) {
                      final w = MediaQuery.of(context).size.width;
                      final x = (-80) + (w + 160) * _planeX.value;

                      return Stack(
                        children: [
                          Container(color: Colors.black.withOpacity(0.04)),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.28,
                            left: x,
                            child: Transform.rotate(
                              angle: -0.15,
                              child: Icon(
                                Icons.flight_takeoff_rounded,
                                size: 44,
                                color: cs.primary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// CalmSpace-style abstract “blobs” (no images needed)
class _AbstractBlobsPainter extends CustomPainter {
  _AbstractBlobsPainter({
    required this.opacity,
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  final double opacity;
  final Color primary;
  final Color secondary;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = primary.withOpacity(opacity);
    final p2 = Paint()..color = secondary.withOpacity(opacity * 0.95);
    final p3 = Paint()..color = accent.withOpacity(opacity * 0.85);

    // Blob 1 (top left)
    final blob1 = Path()
      ..moveTo(size.width * 0.05, size.height * 0.10)
      ..cubicTo(
        size.width * 0.10,
        size.height * 0.02,
        size.width * 0.28,
        size.height * 0.02,
        size.width * 0.30,
        size.height * 0.14,
      )
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.28,
        size.width * 0.12,
        size.height * 0.28,
        size.width * 0.05,
        size.height * 0.18,
      )
      ..close();
    canvas.drawPath(blob1, p2);

    // Blob 2 (bottom right)
    final blob2 = Path()
      ..moveTo(size.width * 0.70, size.height * 0.82)
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.70,
        size.width * 0.98,
        size.height * 0.74,
        size.width * 0.96,
        size.height * 0.90,
      )
      ..cubicTo(
        size.width * 0.94,
        size.height * 1.02,
        size.width * 0.70,
        size.height * 1.00,
        size.width * 0.66,
        size.height * 0.90,
      )
      ..close();
    canvas.drawPath(blob2, p1);

    // Blob 3 (center-ish)
    final blob3 = Path()
      ..moveTo(size.width * 0.55, size.height * 0.34)
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.24,
        size.width * 0.80,
        size.height * 0.30,
        size.width * 0.78,
        size.height * 0.44,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.58,
        size.width * 0.56,
        size.height * 0.54,
        size.width * 0.52,
        size.height * 0.46,
      )
      ..close();
    canvas.drawPath(blob3, p3);

    // Small “accent dots” (adds that abstract vibe)
    final dotPaint = Paint()..color = secondary.withOpacity(opacity * 0.8);
    canvas.drawCircle(
        Offset(size.width * 0.18, size.height * 0.62), 10, dotPaint);
    canvas.drawCircle(
        Offset(size.width * 0.82, size.height * 0.18), 8, dotPaint);
    canvas.drawCircle(
        Offset(size.width * 0.34, size.height * 0.84), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _AbstractBlobsPainter oldDelegate) {
    return oldDelegate.opacity != opacity ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary ||
        oldDelegate.accent != accent;
  }
}

/// Typewriter text with callback when finished.
class _TypewriterText extends StatefulWidget {
  const _TypewriterText({
    required this.text,
    required this.style,
    this.textAlign,
    this.speedMs = 30,
    this.onFinished,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int speedMs;
  final VoidCallback? onFinished;

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: widget.speedMs), (t) {
      if (!mounted) return;

      if (_index >= widget.text.length) {
        t.cancel();
        widget.onFinished?.call();
        return;
      }
      setState(() => _index++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shown = widget.text.substring(0, _index.clamp(0, widget.text.length));
    return Text(
      shown,
      textAlign: widget.textAlign,
      style: widget.style.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
