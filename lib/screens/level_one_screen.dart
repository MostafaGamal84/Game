import 'package:flutter/material.dart';

class LevelOneScreen extends StatefulWidget {
  const LevelOneScreen({super.key});

  @override
  State<LevelOneScreen> createState() => _LevelOneScreenState();
}

class _LevelOneScreenState extends State<LevelOneScreen> {
  static const List<String> _levelImages = [
    'assets/images/LevelOne/bad1.jpg',
    'assets/images/LevelOne/bad2.jpg',
    'assets/images/LevelOne/bad3.jpg',
    'assets/images/LevelOne/bad4.jpg',
    'assets/images/LevelOne/bad5.jpg',
    'assets/images/LevelOne/good1.jpg',
    'assets/images/LevelOne/good2.jpg',
    'assets/images/LevelOne/good3.jpg',
    'assets/images/LevelOne/good4.jpg',
    'assets/images/LevelOne/good5.jpg',
  ];

  int _currentIndex = 0;

  String get _currentImage => _levelImages[_currentIndex];

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
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _IconCircleButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        _IconCircleButton(
                          icon: Icons.account_circle_rounded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      'اختر نوع الصورة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(
                              _currentImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _ChoiceButton(
                            label: 'تشوه بصري',
                            backgroundColor: const Color(0xFFB86A45),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ChoiceButton(
                            label: 'منظر حضاري',
                            backgroundColor: const Color(0xFF00695C),
                            onPressed: () {},
                          ),
                        ),
                      ],
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

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 6,
          shadowColor: backgroundColor.withOpacity(0.45),
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
