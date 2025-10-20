import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'level_selection_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with WidgetsBindingObserver {
  late final AudioPlayer _audioPlayer;
  bool _audioInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    unawaited(_playBackgroundAudio());
  }

  Future<void> _playBackgroundAudio() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource('sounds/intro.mp3'));
    _audioInitialized = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_audioInitialized) return;

    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_audioPlayer.resume());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(_audioPlayer.pause());
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_audioPlayer.stop());
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية الشاشة
          Image.asset(
            'assets/images/main.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),

          // طبقة شفافة
          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          // زر "ابدأ اللعب"
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 60), // 👈 رفعناه فوق شوية
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    width: 220,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E6F5C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _audioPlayer.setVolume(0.35);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LevelSelectionScreen(),
                          ),
                        ).then((_) {
                          if (!mounted) {
                            return;
                          }
                          _audioPlayer.setVolume(1.0);
                        });
                      },
                      label: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('ابدا اللعب'),
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
