import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelOneScreen extends StatelessWidget {
  const LevelOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/levelBackground.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'لعبة خمن الصورة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 32),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const spacing = 18.0;
                        const minCardWidth = 140.0;
                        const maxCardWidth = 194.0;
                        final maxWidth = constraints.maxWidth;

                        double cardWidth;
                        bool useRowLayout = true;

                        if (maxWidth >= (maxCardWidth * 2) + spacing) {
                          cardWidth = maxCardWidth;
                        } else if (maxWidth >= (minCardWidth * 2) + spacing) {
                          cardWidth = (maxWidth - spacing) / 2;
                        } else {
                          cardWidth = maxWidth;
                          useRowLayout = false;
                        }

                        if (useRowLayout) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LevelChoiceCard(
                                title: 'منظر حضاري',
                                backgroundImage: 'assets/images/true.png',
                                width: cardWidth,
                              ),
                              const SizedBox(width: spacing),
                              _LevelChoiceCard(
                                title: 'تشوه بصري',
                                backgroundImage: 'assets/images/false.png',
                                width: cardWidth,
                              ),
                            ],
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _LevelChoiceCard(
                              title: 'منظر حضاري',
                              backgroundImage: 'assets/images/true.png',
                              width: cardWidth,
                            ),
                            const SizedBox(height: spacing),
                            _LevelChoiceCard(
                              title: 'تشوه بصري',
                              backgroundImage: 'assets/images/false.png',
                              width: cardWidth,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 194,
                      height: 62,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00695C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 6,
                          shadowColor: const Color(0xFF00695C).withOpacity(0.35),
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('ابدا اللعب'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelChoiceCard extends StatelessWidget {
  const _LevelChoiceCard({
    required this.title,
    required this.backgroundImage,
    this.width = 194,
    this.height = 102,
  });

  final String title;
  final String backgroundImage;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.35),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
