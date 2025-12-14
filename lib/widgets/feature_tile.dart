import "package:flutter/material.dart";

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.imageAssetPath,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? imageAssetPath;

  static const Color cream = Color(0xFFFFF7E8);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget visual() {
      if (imageAssetPath != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imageAssetPath!,
            width: 62,
            height: 62,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _iconFallback(cs),
          ),
        );
      }
      return _iconFallback(cs);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(24),

          // ✅ bold outline
          border: Border.all(
            color: cs.primary.withOpacity(0.70),
            width: 2.2,
          ),

          // ✅ stronger shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
            // subtle highlight shadow for “soft” look
            BoxShadow(
              color: Colors.white.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              visual(),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withOpacity(0.72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconFallback(ColorScheme cs) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withOpacity(0.25)),
      ),
      child: Icon(icon, color: cs.primary, size: 32),
    );
  }
}
