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
        title: 'إجابة صحيحة!',
        subtitle: 'أحسنت! اخترت التصرف الصحيح للمشهد $sceneNumber.',
      ),
      wrongDescription: _BehaviorDescription(
        title: 'إجابة غير صحيحة',
        subtitle: 'هذا التصرف غير صحيح للمشهد $sceneNumber. جرّب مرة أخرى.',
      ),
    );
  });

  int _currentIndex = 0;
  _ChoiceState _choiceState = _ChoiceState.initial;
  _BehaviorOptionType? _selectedOption;

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
      _selectedOption = type;
      _choiceState =
          type == _BehaviorOptionType.correct ? _ChoiceState.correct : _ChoiceState.wrong;
    });
  }

  void _handleRetry() {
    setState(() {
      _choiceState = _ChoiceState.initial;
      _selectedOption = null;
    });
  }

  void _handleDismissOverlay() {
    setState(() {
      _choiceState = _ChoiceState.initial;
      _selectedOption = null;
    });
  }

  void _handleNext() {
    if (_isLastScenario) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LevelCompletionScreen()),
      );
    } else {
      setState(() {
        _currentIndex++;
        _choiceState = _ChoiceState.initial;
        _selectedOption = null;
      });
    }
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
                    IgnorePointer(
                      ignoring: _choiceState != _ChoiceState.initial,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _choiceState == _ChoiceState.initial ? 1 : 0.3,
                        child: _ChoicesBoard(
                          scenario: _currentScenario,
                          selectedOption: _selectedOption,
                          onSelect: _handleSelect,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          if (_choiceState != _ChoiceState.initial)
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _ResultOverlay(
                  key: ValueKey(_choiceState),
                  scenario: _currentScenario,
                  isSuccess: _choiceState == _ChoiceState.correct,
                  isLastScenario: _isLastScenario,
                  onPrimary: _choiceState == _ChoiceState.correct ? _handleNext : _handleRetry,
                  onClose: _handleDismissOverlay,
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
    required this.onSelect,
    required this.selectedOption,
  });

  final _BehaviorScenario scenario;
  final ValueChanged<_BehaviorOptionType> onSelect;
  final _BehaviorOptionType? selectedOption;

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
                  selectedOption: selectedOption,
                  onTap: () => onSelect(_BehaviorOptionType.correct),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ChoiceTile(
                  assetPath: scenario.wrongAsset,
                  type: _BehaviorOptionType.wrong,
                  selectedOption: selectedOption,
                  onTap: () => onSelect(_BehaviorOptionType.wrong),
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
    required this.assetPath,
    required this.type,
    required this.selectedOption,
    required this.onTap,
  });

  final String assetPath;
  final _BehaviorOptionType type;
  final _BehaviorOptionType? selectedOption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedOption == type;
    final bool showCheck = type == _BehaviorOptionType.correct && isSelected;
    final bool showCross = type == _BehaviorOptionType.wrong && isSelected;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: showCheck
                ? const Color(0xFF00B894)
                : showCross
                    ? const Color(0xFFD63031)
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
              if (showCross)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD63031),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.close,
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

class _ResultOverlay extends StatelessWidget {
  const _ResultOverlay({
    super.key,
    required this.scenario,
    required this.isSuccess,
    required this.isLastScenario,
    required this.onPrimary,
    required this.onClose,
  });

  final _BehaviorScenario scenario;
  final bool isSuccess;
  final bool isLastScenario;
  final VoidCallback onPrimary;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final description = isSuccess ? scenario.correctDescription : scenario.wrongDescription;
    final asset = isSuccess ? scenario.correctAsset : scenario.wrongAsset;
    final indicatorColor = isSuccess ? const Color(0xFF00B894) : const Color(0xFFD63031);
    final indicatorIcon = isSuccess ? Icons.check : Icons.close;
    final primaryLabel = isSuccess
        ? (isLastScenario ? 'إنهاء' : 'متابعة')
        : 'متابعة';

    return Material(
      color: Colors.black.withOpacity(0.75),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'إغلاق',
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Container(
                                  color: const Color(0xFFEFF6F4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      asset,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: indicatorColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: indicatorColor.withOpacity(0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  indicatorIcon,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        description.title,
                        style: textTheme.headlineSmall?.copyWith(
                          color: indicatorColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description.subtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF3B3B3B),
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: indicatorColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: onPrimary,
                          child: Text(primaryLabel),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: indicatorColor.withOpacity(0.6)),
                            foregroundColor: indicatorColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: onClose,
                          child: const Text('إغلاق'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
