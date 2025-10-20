import 'dart:async';
import 'dart:math'; // 👈 لعمل عشوائية

import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../utils/sound_effects.dart';
import 'level_completion_screen.dart';

enum _ChoiceState { initial, correct, wrong }
enum _BehaviorOptionType { correct, wrong }

class _BehaviorScenario {
  const _BehaviorScenario({
    required this.correctAsset,
    required this.wrongAsset,
    required this.title,
    required this.correctMessage,
    required this.wrongMessage,
  });

  final String correctAsset;
  final String wrongAsset;
  final String title;
  final String correctMessage;
  final String wrongMessage;
}

class LevelThreeGameScreen extends StatefulWidget {
  const LevelThreeGameScreen({super.key});

  @override
  State<LevelThreeGameScreen> createState() => _LevelThreeGameScreenState();
}

class _LevelThreeGameScreenState extends State<LevelThreeGameScreen> {
  final List<_BehaviorScenario> _scenarios = const [
    _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct1.png',
      wrongAsset: 'assets/images/LevelThree/wrong1.png',
      title: 'المشهد 1: رمي القمامة في المكان الخاطئ',
      correctMessage: 'رمي القمامة في الحاوية يحافظ على نظافة المكان.',
      wrongMessage: 'إلقاء القمامة على الأرض يسبب الفوضى. جرب اختيار التصرف السليم.',
    ),
    _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct2.png',
      wrongAsset: 'assets/images/LevelThree/wrong2.png',
      title: 'المشهد 2: الكتابة المشوهة على الجدران',
      correctMessage: 'الكتابة في الأماكن المخصصة تحافظ على جمال الجدران.',
      wrongMessage: 'تشويه الجدران بالكتابة يفسد المنظر العام.',
    ),
    _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct3.png',
      wrongAsset: 'assets/images/LevelThree/wrong3.png',
      title: 'المشهد 3: عبور الطريق من المكان الخاطئ',
      correctMessage: 'العبور من ممر المشاة يحميك ويحافظ على النظام.',
      wrongMessage: 'عبور الطريق عشوائياً يعرضك والآخرين للخطر.',
    ),
    _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct4.png',
      wrongAsset: 'assets/images/LevelThree/wrong4.png',
      title: 'المشهد 4: قيادة الدراجة في مسار السيارات',
      correctMessage: 'قيادة الدراجة في مسارها المخصص تبقي الجميع بأمان.',
      wrongMessage: 'التواجد بالدراجة في مسار السيارات يعيق الحركة.',
    ),
    _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct5.png',
      wrongAsset: 'assets/images/LevelThree/wrong5.png',
      title: 'المشهد 5: عدم تنظيم المكان بعد الاستخدام',
      correctMessage: 'ترتيب المكان بعد الاستخدام يعكس احترامك للآخرين.',
      wrongMessage: 'ترك المكان فوضوياً يزعج كل من يستخدمه بعدك.',
    ),
    _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct6.png',
      wrongAsset: 'assets/images/LevelThree/wrong6.png',
      title: 'المشهد 6: إطعام الحمام في الشارع',
      correctMessage: 'تجنب إطعام الطيور في الطريق يحافظ على النظافة.',
      wrongMessage: 'إطعام الحمام في الشارع يجذب الحشرات والأوساخ.',
    ),
    _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct7.png',
      wrongAsset: 'assets/images/LevelThree/wrong7.png',
      title: 'المشهد 7: تجاهل المخاطر أو التصرفات الخاطئة',
      correctMessage: 'الإبلاغ عن السلوكيات الخطرة يحمي الجميع. اتصل على 940 عند ملاحظتها.',
      wrongMessage: 'تجاهل المخاطر يجعلها تتكرر. أخبر الجهات المختصة عبر 940.',
    ),
  ];

  int _currentIndex = 0;
  _ChoiceState _choiceState = _ChoiceState.initial;
  Timer? _advanceTimer;

  // 👇 عشوائية مكان الإجابة الصحيحة (يمين/شمال) لكل مشهد
  final Random _rng = Random();
  bool _correctOnLeft = true;

  @override
  void initState() {
    super.initState();
    _correctOnLeft = _rng.nextBool(); // أول مشهد
  }

  String get _currentBackground {
    switch (_choiceState) {
      case _ChoiceState.initial:
        return 'assets/images/LevelThree/thinking.jpg';
      case _ChoiceState.correct:
        return 'assets/images/LevelThree/happy.jpg';
      case _ChoiceState.wrong:
        return 'assets/images/LevelThree/sad.jpg';
    }
  }

  _BehaviorScenario get _currentScenario => _scenarios[_currentIndex];
  bool get _isLastScenario => _currentIndex == _scenarios.length - 1;

  void _handleSelect(_BehaviorOptionType type) {
    if (_choiceState != _ChoiceState.initial) return;

    SoundEffects.playClaim();
    setState(() {
      _choiceState = (type == _BehaviorOptionType.correct)
          ? _ChoiceState.correct
          : _ChoiceState.wrong;
    });

    if (type == _BehaviorOptionType.correct) {
      _advanceTimer?.cancel();
      _advanceTimer = Timer(const Duration(seconds: 2), _handleNext);
    }
  }

  void _handleRetry() {
    SoundEffects.playClaim();
    setState(() {
      _choiceState = _ChoiceState.initial;
      // نقدر نخلي ترتيب الجهة ثابت وقت الإعادة لنفس المشهد (ما نغيّروش)
      // لو عايز تغييره في كل محاولة، فعّل السطر الجاي:
      // _correctOnLeft = _rng.nextBool();
    });
  }

  void _handleNext() {
    _advanceTimer?.cancel();
    _advanceTimer = null;
    if (!mounted) return;

    if (_isLastScenario) {
      SoundEffects.playCorrect();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LevelCompletionScreen()),
      );
    } else {
      setState(() {
        _currentIndex++;
        _choiceState = _ChoiceState.initial;
        _correctOnLeft = _rng.nextBool(); // 👈 عشوائية للمشهد الجديد
      });
    }
  }

  @override
  void dispose() {
    _advanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Image.asset(
              _currentBackground,
              key: ValueKey<String>(_currentBackground),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final mediaQuery = MediaQuery.of(context);
                final padding = Responsive.symmetricPadding(
                  width,
                  horizontal: 24,
                  vertical: Responsive.scaledValue(
                    width,
                    16,
                    min: 12,
                    max: 32,
                  ),
                  maxContentWidth: Responsive.valueForWidth(
                    width,
                    narrow: 600,
                    wide: 760,
                    breakpoint: 900,
                  ),
                );
                final sectionSpacing = Responsive.scaledValue(
                  width,
                  16,
                  min: 12,
                  max: 28,
                );
                final subtitleSpacing = Responsive.scaledValue(
                  width,
                  12,
                  min: 10,
                  max: 20,
                );
                final footerSpacing = Responsive.scaledValue(
                  width,
                  32,
                  min: 20,
                  max: 48,
                );
                final textScale = Responsive.scaleForWidth(
                  width,
                  baseWidth: 390,
                  minScale: 0.95,
                  maxScale: 1.2,
                );

                return MediaQuery(
                  data: mediaQuery.copyWith(textScaleFactor: textScale),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  SoundEffects.playClaim();
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                                color: Colors.white,
                              ),
                              Text(
                                'المستوى 3',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          SizedBox(height: sectionSpacing),
                          if (_choiceState == _ChoiceState.initial) ...[
                            Text(
                              _currentScenario.title,
                              style: textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: subtitleSpacing),
                          ],
                          const Spacer(),
                          _ChoicesBoard(
                            scenario: _currentScenario,
                            choiceState: _choiceState,
                            onSelect: _handleSelect,
                            onRetry: _handleRetry,
                            correctOnLeft: _correctOnLeft,
                          ),
                          SizedBox(height: footerSpacing),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoicesBoard extends StatelessWidget {
  const _ChoicesBoard({
    super.key,
    required this.scenario,
    required this.choiceState,
    required this.onSelect,
    required this.onRetry,
    required this.correctOnLeft,
  });

  final _BehaviorScenario scenario;
  final _ChoiceState choiceState;
  final ValueChanged<_BehaviorOptionType> onSelect;
  final VoidCallback onRetry;
  final bool correctOnLeft; // 👈 هل الإجابة الصحيحة على اليسار؟

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final containerPadding = EdgeInsets.all(
          Responsive.scaledValue(
            width,
            24,
            min: 16,
            max: 36,
          ),
        );
        final rowSpacing = Responsive.scaledValue(
          width,
          16,
          min: 12,
          max: 24,
        );
        final verticalSpacing = Responsive.scaledValue(
          width,
          24,
          min: 16,
          max: 32,
        );
        final tileHeight = Responsive.scaledValue(
          width,
          240,
          min: 200,
          max: 320,
        );
        final messagePadding = EdgeInsets.all(
          Responsive.scaledValue(
            width,
            20,
            min: 16,
            max: 28,
          ),
        );
        final messageSpacing = Responsive.scaledValue(
          width,
          20,
          min: 16,
          max: 28,
        );
        final retryPadding = Responsive.scaledValue(
          width,
          14,
          min: 12,
          max: 18,
        );

        final correctTile = Expanded(
          child: _ChoiceTile(
            assetPath: scenario.correctAsset,
            type: _BehaviorOptionType.correct,
            choiceState: choiceState,
            isInteractive: choiceState == _ChoiceState.initial,
            onTap: () => onSelect(_BehaviorOptionType.correct),
            height: tileHeight,
          ),
        );

        final wrongSide = Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: choiceState == _ChoiceState.initial
                ? _ChoiceTile(
                    key: const ValueKey('wrong_choice'),
                    assetPath: scenario.wrongAsset,
                    type: _BehaviorOptionType.wrong,
                    choiceState: choiceState,
                    isInteractive: choiceState == _ChoiceState.initial,
                    onTap: () => onSelect(_BehaviorOptionType.wrong),
                    height: tileHeight,
                  )
                : _MessageCard(
                    key: ValueKey<_ChoiceState>(choiceState),
                    message: choiceState == _ChoiceState.correct
                        ? scenario.correctMessage
                        : scenario.wrongMessage,
                    isSuccess: choiceState == _ChoiceState.correct,
                    onRetry: choiceState == _ChoiceState.wrong ? onRetry : null,
                    padding: messagePadding,
                    spacing: messageSpacing,
                    buttonPadding: EdgeInsets.symmetric(vertical: retryPadding),
                  ),
          ),
        );

        final children = correctOnLeft
            ? <Widget>[correctTile, SizedBox(width: rowSpacing), wrongSide]
            : <Widget>[wrongSide, SizedBox(width: rowSpacing), correctTile];

        return Container(
          width: double.infinity,
          padding: containerPadding,
          decoration: BoxDecoration(
            color: const Color(0xFF116A60).withOpacity(0.92),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'أي صورة تمثل السلوك الصحيح؟',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: verticalSpacing),
              Row(children: children),
            ],
          ),
        );
      },
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    super.key,
    required this.assetPath,
    required this.type,
    required this.choiceState,
    required this.isInteractive,
    required this.onTap,
    required this.height,
  });

  final String assetPath;
  final _BehaviorOptionType type;
  final _ChoiceState choiceState;
  final bool isInteractive;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool highlightCorrect =
        type == _BehaviorOptionType.correct && choiceState != _ChoiceState.initial;
    final bool showCheck = highlightCorrect;

    return GestureDetector(
      onTap: isInteractive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // بدون زوايا دائرية
          borderRadius: BorderRadius.zero,
          // بدون إطار بعد الاختيار (حسب طلبك سابقاً)
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D5F56).withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: Image.asset(assetPath),
            ),
            if (showCheck)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00B894),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    super.key,
    required this.message,
    required this.isSuccess,
    this.onRetry,
    required this.padding,
    required this.spacing,
    this.buttonPadding,
  });

  final String message;
  final bool isSuccess;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final EdgeInsetsGeometry? buttonPadding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Color accent = isSuccess ? const Color(0xFF00B894) : const Color(0xFFD63031);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withOpacity(0.35), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D5F56).withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF184F4A),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.start,
          ),
          if (!isSuccess && onRetry != null) ...[
            SizedBox(height: spacing),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  side: BorderSide(color: accent.withOpacity(0.5)),
                  padding: buttonPadding ??
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  SoundEffects.playClaim();
                  onRetry!();
                },
                child: const Text('حاول مرة أخرى'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
