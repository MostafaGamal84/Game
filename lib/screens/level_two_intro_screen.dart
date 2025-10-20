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
          final scale = Responsive.scaleForWidth(
            maxWidth,
            baseWidth: 390,
            minScale: 0.88,
            maxScale: 1.45,
          );
          final horizontalPadding = Responsive.clamp(24 * scale, 16, 64);
          final verticalPadding = Responsive.clamp(32 * scale, 24, 72);
          final buttonWidth = Responsive.clamp(maxWidth * 0.45, 220, 420);
          final buttonHeight = Responsive.clamp(60 * scale, 52, 84);
          final titleFontSize = Responsive.clamp(48 * scale, 34, 66);
          final spacing = Responsive.clamp(24 * scale, 18, 40);
          final buttonFontSize = Responsive.clamp(22 * scale, 18, 30);
          final buttonRadius = Responsive.clamp(28 * scale, 22, 40);
          final iconSize = Responsive.clamp(24 * scale, 20, 32);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/banner.png',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
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
                            icon: Icon(Icons.arrow_back_ios_new_rounded, size: iconSize),
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

                        Center(
                          child: SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E6F5C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(buttonRadius),
                                ),
                                elevation: 6,
                                shadowColor: const Color(0xFF1E6F5C)
                                    .withOpacity(Responsive.clamp(0.35 * scale, 0.2, 0.45)),
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

                        SizedBox(height: spacing),
                      ],
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
