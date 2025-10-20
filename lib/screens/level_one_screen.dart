import 'package:flutter/material.dart';
import 'package:albatal_elsagheer/screens/level_one_photo_screen.dart';

import '../utils/responsive.dart';

class LevelOneScreen extends StatelessWidget {
  const LevelOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    final scale = Responsive.scaleForWidth(
                      maxWidth,
                      baseWidth: 390,
                      minScale: 0.88,
                      maxScale: 1.4,
                    );
                    final spacing = Responsive.clamp(18 * scale, 12, 32);
                    final minCardWidth = Responsive.clamp(140 * scale, 120, 220);
                    final maxCardWidth = Responsive.clamp(194 * scale, 180, 300);
                    final buttonWidth = Responsive.clamp(maxWidth * 0.5, 220, 420);
                    final buttonHeight = Responsive.clamp(60 * scale, 52, 84);
                    final textSize = Responsive.clamp(44 * scale, 32, 60);
                    final topSpacing = Responsive.clamp(48 * scale, 32, 80);
                    final betweenSpacing = Responsive.clamp(32 * scale, 20, 52);
                    final bottomSpacing = Responsive.clamp(28 * scale, 20, 48);

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

                    final cardHeight = Responsive.clamp(cardWidth * 0.52, 110, 220);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: topSpacing),
                        Text(
                          'لعبة خمن الصورة',
                          textAlign: TextAlign.center,
                          style: textTheme.displayMedium?.copyWith(
                            fontSize: textSize,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: betweenSpacing),
                        if (useRowLayout)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LevelChoiceCard(
                                title: 'منظر حضاري',
                                backgroundImage: 'assets/images/true.png',
                                width: cardWidth,
                                height: cardHeight,
                                textScale: scale,
                              ),
                              SizedBox(width: spacing),
                              _LevelChoiceCard(
                                title: 'تشوه بصري',
                                backgroundImage: 'assets/images/false.png',
                                width: cardWidth,
                                height: cardHeight,
                                textScale: scale,
                              ),
                            ],
                          )
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _LevelChoiceCard(
                                title: 'منظر حضاري',
                                backgroundImage: 'assets/images/true.png',
                                width: cardWidth,
                                height: cardHeight,
                                textScale: scale,
                              ),
                              SizedBox(height: spacing),
                              _LevelChoiceCard(
                                title: 'تشوه بصري',
                                backgroundImage: 'assets/images/false.png',
                                width: cardWidth,
                                height: cardHeight,
                                textScale: scale,
                              ),
                            ],
                          ),
                        SizedBox(height: bottomSpacing),

                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E6F5C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 6,
                              shadowColor:
                                  const Color(0xFF1E6F5C).withOpacity(0.35),
                              textStyle: textTheme.titleMedium?.copyWith(
                                fontSize: Responsive.clamp(22 * scale, 18, 30),
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LevelOnePhotoScreen(),
                                ),
                              );
                            },
                            child: const Text('ابدأ اللعب'),
                          ),
                        ),
                      ],
                    );
                  },
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
    this.height,
    this.textScale = 1,
  });

  final String title;
  final String backgroundImage;
  final double width;
  final double? height;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height ?? width * 0.52;

    return SizedBox(
      width: width,
      height: resolvedHeight,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: Responsive.clamp(20 * textScale, 16, 28),
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
