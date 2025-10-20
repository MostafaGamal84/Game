import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'level_one_screen.dart';
import 'level_two_intro_screen.dart';
import 'level_three_intro_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          final buttonWidth = Responsive.clamp(maxWidth * 0.55, 220, 440);
          final buttonHeight = Responsive.clamp(60 * scale, 52, 84);
          final spacingBetweenButtons = Responsive.clamp(20 * scale, 12, 28);
          final maxContentWidth = Responsive.clamp(maxWidth * 0.9, 360, 620);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/levelBackground.png',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'حدد المستوى',
                              textAlign: TextAlign.center,
                              style: textTheme.displaySmall?.copyWith(
                                fontSize: Responsive.clamp(40 * scale, 32, 56),
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: Responsive.clamp(12 * scale, 8, 20)),
                            Text(
                              'اختر المغامرة المناسبة لك وابدأ اللعب!',
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: Responsive.clamp(20 * scale, 16, 26),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: Responsive.clamp(50 * scale, 28, 80)),

                            // أزرار المستويات
                            for (var index = 0; index < 3; index++)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: spacingBetweenButtons / 2,
                                ),
                                child: TweenAnimationBuilder<double>(
                                  duration:
                                      Duration(milliseconds: 700 + index * 120),
                                  curve: Curves.easeOutBack,
                                  tween: Tween<double>(begin: 0, end: 1),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(0, (1 - value) * 40),
                                      child: Transform.scale(
                                        scale: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: SizedBox(
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
                                        shadowColor: const Color(0xFF1E6F5C)
                                            .withOpacity(0.35),
                                        textStyle:
                                            textTheme.titleMedium?.copyWith(
                                          fontSize: Responsive.clamp(
                                            22 * scale,
                                            18,
                                            30,
                                          ),
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (index == 0) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const LevelOneScreen(),
                                            ),
                                          );
                                        } else if (index == 1) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const LevelTwoIntroScreen(),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const LevelThreeIntroScreen(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        const [
                                          'المستوى 1',
                                          'المستوى 2',
                                          'المستوى 3',
                                        ][index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
