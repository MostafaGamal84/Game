import 'package:flutter/material.dart';

import '../utils/sound_effects.dart';
import 'start_screen.dart';

class LevelCompletionScreen extends StatelessWidget {
  const LevelCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/finish.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xAA000000),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 220,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.home_rounded),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E6F5C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                        ),
                        onPressed: () {
                          SoundEffects.playClaim();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const StartScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        label: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text('انهاء المستوى'),
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
