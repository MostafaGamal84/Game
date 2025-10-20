import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/sound_effects.dart';
import 'level_completion_screen.dart';
import '../utils/responsive.dart';

class LevelOnePhotoScreen extends StatefulWidget {
  const LevelOnePhotoScreen({super.key});

  @override
  State<LevelOnePhotoScreen> createState() => _LevelOnePhotoScreenState();
}

class _LevelOnePhotoScreenState extends State<LevelOnePhotoScreen> {
  /// الأساس: بنحدد المسارات + التصنيف فقط (من غير وصف ثابت)
  static const List<PhotoQuestion> _base = [
    // سيّئ
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/bad1.jpg', // تمديدات التكييفات
      category: PhotoCategory.visualPollution,
      description: '', // سنملأه ديناميكياً
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/bad2.jpg', // سيارات تالفة
      category: PhotoCategory.visualPollution,
      description: '',
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/bad3.jpg', // مخلفات البناء
      category: PhotoCategory.visualPollution,
      description: '',
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/bad4.jpg', // أطباق الأقمار
      category: PhotoCategory.visualPollution,
      description: '',
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/bad5.jpg', // هناجر مخالفة
      category: PhotoCategory.visualPollution,
      description: '',
    ),

    // جيّد
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/good1.jpg', // نظافة الأماكن العامة والحدائق
      category: PhotoCategory.civilizedView,
      description: '',
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/good2.jpg', // تناسق ألوان الواجهات
      category: PhotoCategory.civilizedView,
      description: '',
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/good3.jpg', // أطفال ينظفون الحديقة
      category: PhotoCategory.civilizedView,
      description: '',
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/good4.jpg', // إزالة النفايات في المكان المخصص
      category: PhotoCategory.civilizedView,
      description: '',
    ),
    PhotoQuestion(
      assetPath: 'assets/images/LevelOne/good5.jpg', // منظَر حضاري مرتب/حديقة مُعتنى بها
      category: PhotoCategory.civilizedView,
      description: '',
    ),
  ];

  /// أوصاف مناسبة لكل صورة حسب المسار الذي ذكرتَه
  static const Map<String, String> _descriptionsByAsset = {
    // سيّئ (تشوّه بصري)
    'assets/images/LevelOne/bad1.jpg':
        'تمديدات أجهزة التكييف الظاهرة والعشوائية تشوّه واجهات المباني وتعرّض السكان للخطر عند التسرب أو السقوط.',
    'assets/images/LevelOne/bad2.jpg':
        'السيارات التالفة والمتروكة في الشوارع تشغل الأرصفة وتعيق الحركة وتُعد منظراً غير حضاري.',
    'assets/images/LevelOne/bad3.jpg':
        'مخلفات البناء والركام الملقى في غير أماكنه يعرّض المارة للأذى ويشوّه المشهد العام.',
    'assets/images/LevelOne/bad4.jpg':
        'أطباق الأقمار الصناعية المركّبة بشكل عشوائي على الواجهات والأسطح تسبب فوضى بصرية وقد تؤثر على السلامة.',
    'assets/images/LevelOne/bad5.jpg':
        'هناجر أو منشآت مخالفة دون تراخيص تشوّه النسيج العمراني وتخالف الأنظمة البلدية.',

    // جيّد (منظر حضاري)
    'assets/images/LevelOne/good1.jpg':
        'نظافة الحدائق والأماكن العامة تمنح الجميع مساحة آمنة وجميلة للاسترخاء واللعب.',
    'assets/images/LevelOne/good2.jpg':
        'تناسق ألوان واجهات المباني يخلق منظراً حضارياً متّحداً يريح العين ويعكس الذوق العام.',
    'assets/images/LevelOne/good3.jpg':
        'مشاركة الأطفال في تنظيف الحديقة سلوك إيجابي يغرس قيمة المحافظة على البيئة منذ الصغر.',
    'assets/images/LevelOne/good4.jpg':
        'التخلّص من النفايات في الحاويات المخصّصة يحافظ على نظافة الشوارع ويمنع الروائح والحشرات.',
    'assets/images/LevelOne/good5.jpg':
        'اعتناء المجتمع بالمساحات الخضراء وتنظيمها يرفع جودة الحياة ويزيد جمال الحي.',
  };

  /// القائمة التي سنعرضها بعد إضافة الأوصاف وخلط الترتيب
  late final List<PhotoQuestion> _questions;

  int _currentIndex = 0;
  bool? _isAnswerCorrect;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    // جهّز القائمة بالأوصاف الصحيحة لكل عنصر
    final filled = _base.map((q) {
      final desc = _descriptionsByAsset[q.assetPath] ?? '';
      return PhotoQuestion(
        assetPath: q.assetPath,
        category: q.category,
        description: desc,
      );
    }).toList();

    // اعمل Shuffle عشوائي كل مرة تفتح فيها الشاشة
    final rng = Random(DateTime.now().millisecondsSinceEpoch);
    filled.shuffle(rng);
    _questions = filled;
  }

  PhotoQuestion get _currentQuestion => _questions[_currentIndex];
  String get _currentImage => _currentQuestion.assetPath;
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;

  void _onAnswerSelected(PhotoCategory category) {
    if (_showFeedback) return;

    SoundEffects.playClaim();
    final isCorrect = category == _currentQuestion.category;
    setState(() {
      _isAnswerCorrect = isCorrect;
      _showFeedback = true;
    });
  }

  void _handleNextQuestion() {
    if (_isLastQuestion) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LevelCompletionScreen()),
      );
      return;
    }
    setState(() {
      _currentIndex += 1;
      _isAnswerCorrect = null;
      _showFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = Responsive.scaleForWidth(
      screenWidth,
      baseWidth: 390,
      minScale: 0.85,
      maxScale: 1.35,
    );
    final horizontalPadding = Responsive.clamp(24 * scale, 16, 48);
    final verticalPadding = Responsive.clamp(24 * scale, 16, 48);
    final titleFontSize = Responsive.clamp(34 * scale, 26, 48);
    final topSpacing = Responsive.clamp(36 * scale, 24, 64);
    final betweenSpacing = Responsive.clamp(24 * scale, 18, 42);
    final choiceSpacing = Responsive.clamp(16 * scale, 12, 28);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/levelBackground.png', fit: BoxFit.cover),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: topSpacing),
                    Text(
                      'اختر نوع الصورة',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: betweenSpacing),
                    Expanded(
                      child: Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            final imageWidth = Responsive.clamp(
                              availableWidth * 0.72,
                              Responsive.valueForWidth<double>(
                                availableWidth,
                                narrow: 260,
                                wide: 320,
                              ),
                              Responsive.valueForWidth<double>(
                                availableWidth,
                                narrow: 380,
                                wide: 520,
                                breakpoint: 900,
                              ),
                            );
                            final imageHeight = Responsive.clamp(
                              imageWidth * 0.75,
                              220,
                              Responsive.valueForWidth<double>(
                                availableWidth,
                                narrow: 360,
                                wide: 420,
                              ),
                            );

                            return Container(
                              constraints: BoxConstraints(
                                maxWidth: imageWidth,
                                maxHeight: imageHeight,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Responsive.clamp(28 * scale, 20, 42)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: Responsive.clamp(20 * scale, 12, 28),
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Responsive.clamp(28 * scale, 20, 42)),
                                child: Image.asset(
                                  _currentImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: betweenSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: _ChoiceButton(
                            label: 'تشوه بصري',
                            backgroundColor: const Color(0xFFA66B55),
                            textColor: const Color(0xFFF7E7DC),
                            scale: scale,
                            onPressed: _showFeedback
                                ? null
                                : () => _onAnswerSelected(PhotoCategory.visualPollution),
                          ),
                        ),
                        SizedBox(width: choiceSpacing),
                        Expanded(
                          child: _ChoiceButton(
                            label: 'منظر حضاري',
                            backgroundColor: const Color(0xFF1E6F5C),
                            textColor: const Color(0xFFEAF5EE),
                            scale: scale,
                            onPressed: _showFeedback
                                ? null
                                : () => _onAnswerSelected(PhotoCategory.civilizedView),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // طبقة التغذية الراجعة
          if (_showFeedback && _isAnswerCorrect != null)
            _AnswerFeedbackOverlay(
              question: _currentQuestion,
              isCorrect: _isAnswerCorrect!,
              isLastQuestion: _isLastQuestion,
              onNext: _handleNextQuestion,
              onTryAgain: () {
                setState(() {
                  _showFeedback = false;
                  _isAnswerCorrect = null;
                });
              },
            ),
        ],
      ),
    );
  }
}

class PhotoQuestion {
  const PhotoQuestion({
    required this.assetPath,
    required this.category,
    required this.description,
  });

  final String assetPath;
  final PhotoCategory category;
  final String description;
}

enum PhotoCategory { visualPollution, civilizedView }

class _AnswerFeedbackOverlay extends StatelessWidget {
  const _AnswerFeedbackOverlay({
    required this.question,
    required this.isCorrect,
    required this.isLastQuestion,
    required this.onNext,
    required this.onTryAgain,
  });

  final PhotoQuestion question;
  final bool isCorrect;
  final bool isLastQuestion;
  final VoidCallback onNext;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final Color accentColor =
        isCorrect ? const Color(0xFF1E6F5C) : const Color(0xFFA8443D);
    final IconData icon =
        isCorrect ? Icons.check_circle_rounded : Icons.close_rounded;
    final String title = isCorrect ? 'إجابة صحيحة' : 'إجابة خاطئة';
    final String buttonLabel =
        isCorrect ? (isLastQuestion ? 'إنهاء' : 'التالي') : 'حاول مجدداً';

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final overlayScale = Responsive.scaleForWidth(
            constraints.maxWidth,
            baseWidth: 390,
            minScale: 0.85,
            maxScale: 1.35,
          );
          final contentMaxWidth = Responsive.clamp(
            constraints.maxWidth * 0.8,
            320,
            560,
          );
          final horizontalPadding = Responsive.clamp(24 * overlayScale, 16, 42);
          final verticalPadding = Responsive.clamp(32 * overlayScale, 20, 54);
          final borderRadius = Responsive.clamp(28 * overlayScale, 20, 40);
          final iconSize = Responsive.clamp(48 * overlayScale, 38, 64);
          final iconPadding = Responsive.clamp(12 * overlayScale, 8, 18);
          final spacingSmall = Responsive.clamp(16 * overlayScale, 12, 24);
          final spacingMedium = Responsive.clamp(18 * overlayScale, 14, 28);
          final spacingLarge = Responsive.clamp(24 * overlayScale, 18, 34);
          final imageHeight = Responsive.clamp(160 * overlayScale, 140, 260);
          final descriptionFontSize = Responsive.clamp(20 * overlayScale, 16, 26);
          final buttonFontSize = Responsive.clamp(20 * overlayScale, 16, 26);
          final buttonPadding = Responsive.clamp(16 * overlayScale, 14, 22);
          final buttonRadius = Responsive.clamp(22 * overlayScale, 18, 32);

          return Container(
            color: Colors.black.withOpacity(0.55),
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      verticalPadding,
                      horizontalPadding,
                      Responsive.clamp(24 * overlayScale, 18, 32),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3),
                          blurRadius: Responsive.clamp(28 * overlayScale, 18, 40),
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(iconPadding),
                          child: Icon(icon, color: accentColor, size: iconSize),
                        ),
                        SizedBox(height: spacingSmall),
                        Text(
                          title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(height: spacingMedium),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              Responsive.clamp(22 * overlayScale, 18, 30)),
                          child: Image.asset(
                            question.assetPath,
                            height: imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: spacingMedium),
                        Text(
                          isCorrect
                              ? question.description
                              : 'فكّر مرة أخرى ولاحظ تفاصيل الصورة لتحديد الاختيار الصحيح.',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: descriptionFontSize,
                            height: 1.5,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                        SizedBox(height: spacingLarge),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(buttonRadius),
                              ),
                              padding:
                                  EdgeInsets.symmetric(vertical: buttonPadding),
                              textStyle: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: buttonFontSize,
                              ),
                            ),
                            onPressed: () {
                              SoundEffects.playClaim();
                              if (isCorrect) {
                                if (isLastQuestion) {
                                  Future<void>.delayed(
                                    const Duration(milliseconds: 150),
                                    SoundEffects.playCorrect,
                                  );
                                }
                                onNext();
                              } else {
                                onTryAgain();
                              }
                            },
                            child: Text(buttonLabel),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
    this.textColor = Colors.white,
    this.scale = 1,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isEnabled = onPressed != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final widthScale = Responsive.scaleForWidth(
          constraints.maxWidth,
          baseWidth: 180,
          minScale: 0.9,
          maxScale: 1.2,
        );
        final combinedScale = Responsive.clamp(scale * widthScale, 0.9, 1.4);
        final height = Responsive.clamp(64 * combinedScale, 52, 92);
        final borderRadius = Responsive.clamp(18 * combinedScale, 14, 28);
        final blurRadius = Responsive.clamp(18 * combinedScale, 12, 28);
        final fontSize = Responsive.clamp(22 * combinedScale, 18, 30);

        return SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  isEnabled ? backgroundColor : backgroundColor.withOpacity(0.55),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(isEnabled ? 0.38 : 0.15),
                  blurRadius: blurRadius,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: isEnabled
                    ? () {
                        SoundEffects.playClaim();
                        onPressed!();
                      }
                    : null,
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      color: isEnabled
                          ? textColor
                          : textColor.withOpacity(0.7),
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
