import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'level_two_game_screen.dart';

class LevelTwoIntroScreen extends StatelessWidget {
  const LevelTwoIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final baseTitleStyle =
        textTheme.displayLarge ?? textTheme.headlineLarge ?? const TextStyle(fontSize: 48);

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final padding = MediaQuery.of(context).padding;
          final availableHeight = math.max(0, maxHeight - padding.vertical).toDouble();
          final widthScale = Responsive.scaleForWidth(
            maxWidth,
            baseWidth: 390,
            minScale: 0.9,
            maxScale: 1.55,
          );
          final heightScale = Responsive.clamp(availableHeight / 780, 0.9, 1.2);
          final scale = math.min(widthScale, heightScale);
          final contentMaxWidth = Responsive.clamp(maxWidth * 0.68, 360, 620);
          final contentHorizontalPadding = Responsive.clamp(28 * scale, 18, 56);
          final contentVerticalPadding = Responsive.clamp(availableHeight * 0.08, 24, 72);
          final buttonHeight = Responsive.clamp(60 * scale, 52, 84);
          final titleFontSize = Responsive.clamp(48 * scale, 36, 66);
          final spacing = Responsive.clamp(24 * scale, 18, 40);
          final buttonFontSize = Responsive.clamp(22 * scale, 18, 30);
          final buttonRadius = Responsive.clamp(28 * scale, 22, 40);
          final iconSize = Responsive.clamp(26 * scale, 22, 38);
          final buttonShadowOpacity = Responsive.clamp(0.32 * scale, 0.2, 0.45);

          const bannerAspectRatio = 440 / 956;
          final safeBannerHeight = availableHeight > 0 ? availableHeight : maxHeight;
          final screenAspectRatio = maxWidth / maxHeight;
          double bannerWidth;
          double bannerHeight;
          if (screenAspectRatio > bannerAspectRatio) {
            bannerHeight = safeBannerHeight;
            bannerWidth = bannerHeight * bannerAspectRatio;
          } else {
            bannerWidth = maxWidth;
            bannerHeight = bannerWidth / bannerAspectRatio;
            if (bannerHeight > safeBannerHeight) {
              bannerHeight = safeBannerHeight;
              bannerWidth = bannerHeight * bannerAspectRatio;
            }
          }
          final buttonMaxWidth = Responsive.clamp(contentMaxWidth * 0.65, 240, 460);
          final bannerPadding = EdgeInsets.only(
            top: padding.top,
            bottom: padding.bottom,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              const Positioned.fill(
                child: ColoredBox(color: Colors.black),
              ),
              Padding(
                padding: bannerPadding,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: bannerWidth,
                    height: bannerHeight,
                    child: Image.asset(
                      'assets/images/banner.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: bannerPadding,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E6F5C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            SizedBox(height: spacing),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'لعبة\nابحث عن التشوه',
                                textAlign: TextAlign.center,
                                style: baseTitleStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: titleFontSize,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: buttonMaxWidth,
                                ),
                                child: SizedBox(
                                  height: buttonHeight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E6F5C),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(buttonRadius),
                                      ),
                                      elevation: 8,
                                      shadowColor: const Color(0xFF1E6F5C)
                                          .withOpacity(buttonShadowOpacity),
                                      textStyle: textTheme.titleMedium?.copyWith(
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const LevelTwoGameScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text('ابدأ اللعب'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
