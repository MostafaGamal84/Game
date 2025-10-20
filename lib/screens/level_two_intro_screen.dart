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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final scale = Responsive.scaleForWidth(
            maxWidth,
            baseWidth: 390,
            minScale: 0.88,
            maxScale: 1.55,
          );
          final contentMaxWidth = Responsive.clamp(maxWidth * 0.9, 360, 680);
          final contentHorizontalPadding = Responsive.clamp(24 * scale, 16, 48);
          final contentVerticalPadding = Responsive.clamp(32 * scale, 24, 64);
          final buttonHeight = Responsive.clamp(60 * scale, 52, 86);
          final titleFontSize = Responsive.clamp(48 * scale, 36, 68);
          final spacing = Responsive.clamp(24 * scale, 18, 44);
          final buttonFontSize = Responsive.clamp(22 * scale, 18, 32);
          final buttonRadius = Responsive.clamp(28 * scale, 22, 42);
          final iconSize = Responsive.clamp(24 * scale, 22, 36);
          final buttonShadowOpacity = Responsive.clamp(0.35 * scale, 0.2, 0.5);

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/banner.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: contentMaxWidth,
                        maxHeight: maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: contentHorizontalPadding,
                          vertical: contentVerticalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: iconSize,
                                ),
                                color: Colors.white,
                              ),
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
                                  maxWidth: Responsive.clamp(contentMaxWidth * 0.7, 240, 480),
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
