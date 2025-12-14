import "package:flutter/material.dart";
import "theme/app_theme.dart";
import "screens/home_screen.dart";

void main() {
  runApp(const TravelItineraryApp());
}

class TravelItineraryApp extends StatelessWidget {
  const TravelItineraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Travel Itinerary",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}
