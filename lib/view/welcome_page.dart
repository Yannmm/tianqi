import 'dart:ui';
import 'package:flutter/material.dart';

class WelcomePageNaturalFade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final imageHeight = h * 0.8;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient behind the fade
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF121212), // near the image bottom color
                  Color(0xFF000000),
                ],
              ),
            ),
          ),

          // Image + fade out mask
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Stack(
              children: [
                // Original image
                Positioned.fill(
                  child: Image.asset(
                    "assets/welcome4.jpg",
                    fit: BoxFit.cover,
                  ),
                ),

                // Bottom fade (the KEY to natural transition)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0, 0.1), // fade starts near bottom
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black26, // soft fade
                          Colors.black54, // deeper fade
                          Colors.black, // merge seamlessly
                        ],
                        stops: [0.0, 0.4, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content below the fade
          Positioned(
            top: imageHeight - 80, // overlap the fade a bit
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Your garage companion is ready.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
