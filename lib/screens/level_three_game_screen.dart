import 'dart:async';

import 'package:flutter/material.dart';

import 'level_completion_screen.dart';

enum _ChoiceState { initial, correct, wrong }

enum _BehaviorOptionType { correct, wrong }

class _BehaviorScenario {
  const _BehaviorScenario({
    required this.correctAsset,
    required this.wrongAsset,
    required this.question,
    required this.correctDescription,
    required this.wrongDescription,
  });

  final String correctAsset;
  final String wrongAsset;
  final String question;
  final _BehaviorDescription correctDescription;
  final _BehaviorDescription wrongDescription;
}

class _BehaviorDescription {
  const _BehaviorDescription({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}

class LevelThreeGameScreen extends StatefulWidget {
  const LevelThreeGameScreen({super.key});

  @override
  State<LevelThreeGameScreen> createState() => _LevelThreeGameScreenState();
}

class _LevelThreeGameScreenState extends State<LevelThreeGameScreen> {
  final List<_BehaviorScenario> _scenarios = List.generate(7, (index) {
    final sceneNumber = index + 1;

    return _BehaviorScenario(
      correctAsset: 'assets/images/LevelThree/correct$sceneNumber.png',
      wrongAsset: 'assets/images/LevelThree/wrong$sceneNumber.png',
      question: 'اختر السلوك الصحيح',
      correctDescription: _BehaviorDescription(
        title: 'أحسنت!',
        subtitle: 'اخترت التصرف الصحيح للمشهد $sceneNumber. سيتم الانتقال للمشهد التالي تلقائيًا.',
      ),
      wrongDescription: _BehaviorDescription(
        title: 'إجابة غير صحيحة',
        subtitle: 'هذا التصرف غير صحيح للمشهد $sceneNumber. اقرأ التوجيه ثم جرّب مرة أخرى.',
      ),
    );
  });

  int _currentIndex = 0;
  _ChoiceState _choiceState = _ChoiceState.initial;
  Timer? _advanceTimer;

  String get _currentBackground {
    switch (_choiceState) {
      case _ChoiceState.initial:
        return 'assets/images/LevelThree/thinking.jpg';
      case _ChoiceState.correct:
        return 'assets/images/LevelThree/happy.jpg';
      case _ChoiceState.wrong:
        return 'assets/images/LevelThree/sad.png';
    }
  }

  _BehaviorScenario get _currentScenario => _scenarios[_currentIndex];

  bool get _isLastScenario => _currentIndex == _scenarios.length - 1;

  void _handleSelect(_BehaviorOptionType type) {
    if (_choiceState != _ChoiceState.initial) {
      return;
    }

    setState(() {
      _choiceState =
          type == _BehaviorOptionType.correct ? _ChoiceState.correct : _ChoiceState.wrong;
    });

    if (type == _BehaviorOptionType.correct) {
      _advanceTimer?.cancel();
      _advanceTimer = Timer(const Duration(seconds: 2), _handleNext);
    }
  }

  void _handleRetry() {
    setState(() {
      _choiceState = _ChoiceState.initial;
    });
  }

  void _handleNext() {
    _advanceTimer?.cancel();
    _advanceTimer = null;

    if (!mounted) {
      return;
    }

    if (_isLastScenario) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LevelCompletionScreen()),
      );
    } else {
      setState(() {
        _currentIndex++;
        _choiceState = _ChoiceState.initial;
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
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                    const SizedBox(height: 16),
                    Text(
                      _choiceState == _ChoiceState.initial
                          ? _currentScenario.question
                          : _choiceState == _ChoiceState.correct
                              ? _currentScenario.correctDescription.title
                              : _currentScenario.wrongDescription.title,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _choiceState == _ChoiceState.initial
                          ? 'فكر جيدًا واختر الصورة التي تمثل التصرف السليم.'
                          : _choiceState == _ChoiceState.correct
                              ? _currentScenario.correctDescription.subtitle
                              : _currentScenario.wrongDescription.subtitle,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    _ChoicesBoard(
                      scenario: _currentScenario,
                      choiceState: _choiceState,
                      onSelect: _handleSelect,
                      onRetry: _handleRetry,
                    ),
                    const SizedBox(height: 32),
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

class _ChoicesBoard extends StatelessWidget {
  const _ChoicesBoard({
    super.key,
    required this.scenario,
    required this.choiceState,
    required this.onSelect,
    required this.onRetry,
  });

  final _BehaviorScenario scenario;
  final _ChoiceState choiceState;
  final ValueChanged<_BehaviorOptionType> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _ChoiceTile(
                  assetPath: scenario.correctAsset,
                  type: _BehaviorOptionType.correct,
                  choiceState: choiceState,
                  isInteractive: choiceState == _ChoiceState.initial,
                  onTap: () => onSelect(_BehaviorOptionType.correct),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                        )
                      : _ExplanationCard(
                          key: ValueKey<_ChoiceState>(choiceState),
                          description: choiceState == _ChoiceState.correct
                              ? scenario.correctDescription
                              : scenario.wrongDescription,
                          isSuccess: choiceState == _ChoiceState.correct,
                          onRetry: choiceState == _ChoiceState.wrong ? onRetry : null,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
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
  });

  final String assetPath;
  final _BehaviorOptionType type;
  final _ChoiceState choiceState;
  final bool isInteractive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool highlightCorrect =
        type == _BehaviorOptionType.correct && choiceState != _ChoiceState.initial;
    final bool showCheck = highlightCorrect;

    return GestureDetector(
      onTap: isInteractive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: highlightCorrect
                ? const Color(0xFF00B894)
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D5F56).withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (showCheck)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00B894),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({
    super.key,
    required this.description,
    required this.isSuccess,
    this.onRetry,
  });

  final _BehaviorDescription description;
  final bool isSuccess;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Color accent = isSuccess ? const Color(0xFF00B894) : const Color(0xFFD63031);

    return Container(
      padding: const EdgeInsets.all(20),
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
            description.title,
            style: textTheme.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description.subtitle,
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF184F4A),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (!isSuccess && onRetry != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  side: BorderSide(color: accent.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: onRetry,
                child: const Text('حاول مرة أخرى'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
