import "package:flutter/material.dart";

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget pill(String text, IconData icon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.primary.withOpacity(0.16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: cs.onSurface),
            const SizedBox(width: 8),
            Text(text,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    Widget card({
      required String title,
      required String subtitle,
      required IconData icon,
      required String cta,
    }) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cs.tertiary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: cs.onSurface),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                          color: cs.onSurface.withOpacity(0.65), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Demo: would open $title results")),
                  );
                },
                child: Text(cta),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Find stays & transportation (demo)",
              style: TextStyle(
                  color: cs.onSurface.withOpacity(0.75), fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                pill("Hotels", Icons.hotel),
                pill("Airbnb", Icons.home_work_outlined),
                pill("Flights", Icons.flight),
                pill("Local rides", Icons.directions_car),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                children: [
                  card(
                    title: "Hotels near you",
                    subtitle: "Mock results with filters later",
                    icon: Icons.hotel_outlined,
                    cta: "Search",
                  ),
                  card(
                    title: "Cozy stays",
                    subtitle: "Placeholder list for your demo",
                    icon: Icons.home_outlined,
                    cta: "Browse",
                  ),
                  card(
                    title: "Transportation",
                    subtitle: "Flights / train / rideshare section (demo)",
                    icon: Icons.alt_route,
                    cta: "Open",
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
