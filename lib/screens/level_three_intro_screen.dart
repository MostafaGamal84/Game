import 'package:flutter/material.dart';

import 'level_three_game_screen.dart';

class LevelThreeIntroScreen extends StatelessWidget {
  const LevelThreeIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final baseTitleStyle =
        textTheme.displayLarge ?? textTheme.headlineLarge ?? const TextStyle(fontSize: 48);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/LevelThree/levelThreeBackground.jpg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'لعبة\nالسلوك الصحيح',
                        textAlign: TextAlign.center,
                        style: baseTitleStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 48,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // ✅ زر موحد الحجم والتصميم مثل باقي الشاشات
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
                            elevation: 6,
                            shadowColor: const Color(0xFF1E6F5C).withOpacity(0.35),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const LevelThreeGameScreen(),
                              ),
                            );
                          },
                          child: const Text('ابدأ اللعب'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
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
