import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CarouselSliderController _controller = CarouselSliderController();

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: CarouselSlider(
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Text(
                        'text $i',
                        style: TextStyle(fontSize: 16.0),
                      ));
                },
              );
            }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3, 4, 5].asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );

    // return Scaffold(
    //   body: CarouselSlider(
    //     options: CarouselOptions(height: 400.0),
    //     items: [1, 2, 3, 4, 5].map((i) {
    //       return Builder(
    //         builder: (BuildContext context) {
    //           return Container(
    //               width: MediaQuery.of(context).size.width,
    //               // margin: EdgeInsets.symmetric(horizontal: 5.0),
    //               decoration: BoxDecoration(color: Colors.amber),
    //               child: Text(
    //                 'text $i',
    //                 style: TextStyle(fontSize: 16.0),
    //               ));
    //         },
    //       );
    //     }).toList(),
    //   ),
    // );
  }
}

class _Wrapper extends StatelessWidget {
  const _Wrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final imageHeight = h * 0.8;

    return Stack(
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
                  "assets/welcome5.jpg",
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "TRACK FUEL CONSUMPTION",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
