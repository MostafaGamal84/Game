import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
        useMaterial3: true,
        textTheme: GoogleFonts.tajawalTextTheme(),
        fontFamily: GoogleFonts.tajawal().fontFamily,
      ),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFEAF4FB),
            ),
          ),
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/main.png'),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00695C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                        elevation: 6,
                        shadowColor: const Color(0xFF00695C).withOpacity(0.45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LevelSelectionScreen(),
                          ),
                        );
                      },
                      label: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('ابدأ اللعب'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'حدد المستوى',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'اختر المغامرة المناسبة لك وابدأ اللعب!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00695C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: 6,
                              shadowColor: const Color(0xFF00695C).withOpacity(0.35),
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: () {
                              // TODO: Navigate to the chosen level screen.
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
                                Text([
                                  'المستوى 1',
                                  'المستوى 2',
                                  'المستوى 3',
                                ][index]),
                              ],
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
