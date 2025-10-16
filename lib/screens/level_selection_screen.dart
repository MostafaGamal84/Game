import 'package:flutter/material.dart';

import '../utils/sound_effects.dart';
import 'level_one_screen.dart';
import 'level_two_intro_screen.dart';
import 'level_three_intro_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'اختر المغامرة المناسبة لك وابدأ اللعب!',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    for (var index = 0; index < 3; index++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 700 + index * 120),
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
                            width: 194,
                            height: 102,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00695C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                elevation: 6,
                                shadowColor:
                                    const Color(0xFF00695C).withOpacity(0.35),
                                textStyle: textTheme.titleMedium?.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                SoundEffects.playClaim();
                                if (index == 0) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LevelOneScreen(),
                                    ),
                                  );
                                } else if (index == 1) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LevelTwoIntroScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LevelThreeIntroScreen(),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    [
                                      Icons.looks_one_rounded,
                                      Icons.looks_two_rounded,
                                      Icons.looks_3_rounded,
                                    ][index],
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    [
                                      'المستوى 1',
                                      'المستوى 2',
                                      'المستوى 3',
                                    ][index],
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
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
        ],
      ),
    );
  }
}
