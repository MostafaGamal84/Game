import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../utils/sound_effects.dart';
import 'level_completion_screen.dart';

class LevelTwoGameScreen extends StatefulWidget {
  const LevelTwoGameScreen({super.key});

  @override
  State<LevelTwoGameScreen> createState() => _LevelTwoGameScreenState();
}

class _LevelTwoGameScreenState extends State<LevelTwoGameScreen>
    with TickerProviderStateMixin {
  static const bool kDesignMode = false;

  final List<_ViolationSpot> _spots = const [
    _ViolationSpot(
      id: 'illegalHangars',
      area: Rect.fromLTWH(0.12, 0.32, 0.80, 0.08),
      title: 'الهناجر المخالفة',
      description:
          'وجود هناجر أو منشآت غير مرخصة يشوّه المشهد العمراني ويخالف الأنظمة البلدية.',
    ),
    _ViolationSpot(
      id: 'satelliteDishes',
      area: Rect.fromLTWH(0.031, 0.423, 0.109, 0.043),
      title: 'أطباق الأقمار الصناعية',
      description:
          'تركيب الأطباق بطريقة عشوائية على الأسطح أو الواجهات يسبب تشوهاً بصرياً ويؤثر على السلامة العامة.',
    ),
    _ViolationSpot(
      id: 'wallGraffiti',
      area: Rect.fromLTWH(0.103, 0.473, 0.083, 0.025),
      title: 'الكتابة المشوهة للجدران',
      description:
          'الكتابات أو الرسوم العشوائية على الجدران تقلل من جمالية المكان وتخالف الذوق العام.',
    ),
    _ViolationSpot(
      id: 'exposedACLeft',
      area: Rect.fromLTWH(0.143, 0.631, 0.192, 0.058),
      title: 'التكييفات المكشوفة',
      description:
          'ترك أجهزة التكييف الخارجية مكشوفة دون غطاء مناسب يشوه واجهة المبنى ويؤثر على مظهره العام.',
    ),
    _ViolationSpot(
      id: 'exposedACRight',
      area: Rect.fromLTWH(0.685, 0.632, 0.165, 0.049),
      title: 'التكييفات المكشوفة',
      description:
          'تركيب أجهزة التكييف بطريقة غير منظمة أو ترك الأسلاك ظاهرة يضر بالمظهر الجمالي للمبنى.',
    ),
    _ViolationSpot(
      id: 'illegalShades',
      area: Rect.fromLTWH(0.247, 0.730, 0.507, 0.070),
      title: 'المظلات',
      description:
          'تركيب مظلات بشكل عشوائي أو دون تصريح رسمي يخل بالنظام البصري للشارع ويعيق حركة المشاة.',
    ),
    _ViolationSpot(
      id: 'graffitiLow',
      area: Rect.fromLTWH(0.779, 0.745, 0.139, 0.043),
      title: 'الكتابة المشوهة للجدران',
      description:
          'الكتابات غير المرخصة على واجهات المحال أو الجدران تشوه المظهر العام وتقلل من جاذبية الموقع.',
    ),
    _ViolationSpot(
      id: 'inappropriateSign',
      area: Rect.fromLTWH(0.680, 0.812, 0.178, 0.043),
      title: 'لافتة غير مناسبة',
      description:
          'اللافتات الباهتة أو غير المتوافقة مع معايير التصميم الحضري تشوه المنظر وتخالف التعليمات.',
    ),
    _ViolationSpot(
      id: 'illegalAds',
      area: Rect.fromLTWH(0.023, 0.854, 0.072, 0.032),
      title: 'إعلانات مخالفة',
      description:
          'وضع الإعلانات دون تصريح أو في أماكن غير مخصصة يعرضها للإزالة ويشوّه الواجهة العامة.',
    ),
  ];

  final Set<String> _found = <String>{};
  _ViolationSpot? _activeSpot;
  bool _lastTapWasNew = false;

  // مرحلة اللمعات المتتابعة (بدون Glare لكل عنصر)
  late final AnimationController _flashCtrl; // 0→1
  bool _playFinish = false;

  // الصورة النهائية + glare عام
  late final AnimationController _finalCtrl; // 0→1
  late final Animation<double> _finalFade;
  late final Animation<double> _fullGlare;

  bool _showFinalLayer = false;

  // نبضة العداد
  double _counterPulse = 1.0;

  @override
  void initState() {
    super.initState();

    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..addStatusListener((s) async {
        if (s == AnimationStatus.completed && mounted) {
          // بعد اللمعات: فعّل طبقة الصورة النهائية وابدأ الـ glare العام + صوت النهاية
          setState(() => _showFinalLayer = true);
          SoundEffects.playCorrect();
          _finalCtrl.forward(from: 0);
        }
      });

    _finalCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _finalFade = CurvedAnimation(parent: _finalCtrl, curve: Curves.easeInOut);
    _fullGlare = CurvedAnimation(parent: _finalCtrl, curve: Curves.easeOutCubic);

  }

  @override
  void dispose() {
    _flashCtrl.dispose();
    _finalCtrl.dispose();
    super.dispose();
  }

  int get _foundCount => _found.length;
  int get _totalCount => _spots.length;
  bool get _allFound => _foundCount == _totalCount;

  void _pulseCounter() async {
    setState(() => _counterPulse = 1.08);
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => _counterPulse = 1.0);
  }

  Future<void> _handleSpotTap(_ViolationSpot spot) async {
    SoundEffects.playClaim();
    final alreadyFound = _found.contains(spot.id);
    setState(() {
      _found.add(spot.id);
      _activeSpot = spot;
      _lastTapWasNew = !alreadyFound;
    });
    if (!alreadyFound) {
      _pulseCounter();
    }
  }

  void _handleCloseInfo() {
    SoundEffects.playClaim();
    setState(() => _activeSpot = null);

    if (_allFound && !_playFinish) {
      setState(() {
        _playFinish = true;
        _showFinalLayer = false;
      });
      // ابدأ لمعات العناصر (بدون Glare، مجرد flash)
      _flashCtrl.forward(from: 0);
    }
  }

  void _goToCompletion() {
    SoundEffects.playClaim();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LevelCompletionScreen()),
    );
  }

  void _onNewRectFromDesign(Rect r) {
    debugPrint(
      'Rect.fromLTWH(${r.left.toStringAsFixed(3)}, ${r.top.toStringAsFixed(3)}, ${r.width.toStringAsFixed(3)}, ${r.height.toStringAsFixed(3)})',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية + التفاعل
          IgnorePointer(
            ignoring: _playFinish,
            child: _LevelTwoScene(
              spots: _spots,
              found: _found,
              onSpotTap: _handleSpotTap,
              designMode: kDesignMode,
              onNewRect: _onNewRectFromDesign,
            ),
          ),

          // لمعات العناصر المتتابعة (flash فقط)
          if (_playFinish)
            Positioned.fill(
              child: _SequentialSpotFlashes(
                progress: _flashCtrl,
                spots: _spots,
                designWidth: _LevelTwoScene.designWidth,
                designHeight: _LevelTwoScene.designHeight,
              ),
            ),

          // الصورة النهائية + glare عام واحد
          if (_showFinalLayer)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _finalCtrl,
                builder: (context, _) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: _finalFade.value,
                        child: Image.asset(
                          'assets/images/LevelTwo/finishLevelTwo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      _FullScreenGlare(progress: _fullGlare.value),
                    ],
                  );
                },
              ),
            ),

          // HUD أعلى الشاشة
          if (!_playFinish) const _TopHud(),

          // كارت الشرح
          if (_activeSpot != null)
            _ViolationInfoCard(
              spot: _activeSpot!,
              onDismiss: _handleCloseInfo,
              isFirstTime: _lastTapWasNew,
            ),

          // متابعة بعد النهاية
          if (_showFinalLayer)
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final padding = EdgeInsets.fromLTRB(
                    Responsive.horizontalPadding(
                      width,
                      minPadding: 20,
                      maxContentWidth: 600,
                    ),
                    0,
                    Responsive.horizontalPadding(
                      width,
                      minPadding: 20,
                      maxContentWidth: 600,
                    ),
                    Responsive.scaledValue(
                      width,
                      20,
                      min: 16,
                      max: 36,
                    ),
                  );
                  final buttonPadding = EdgeInsets.symmetric(
                    vertical: Responsive.scaledValue(
                      width,
                      14,
                      min: 12,
                      max: 18,
                    ),
                  );

                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: padding,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E6F5C),
                            foregroundColor: Colors.white,
                            padding: buttonPadding,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: _goToCompletion,
                          child: Text(
                            'متابعة',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
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

/// HUD مثبت أعلى الشاشة
class _TopHud extends StatefulWidget {
  const _TopHud({super.key});

  @override
  State<_TopHud> createState() => _TopHudState();
}

class _TopHudState extends State<_TopHud> {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_LevelTwoGameScreenState>()!;
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = Responsive.horizontalPadding(
              width,
              minPadding: 12,
              maxContentWidth: 720,
            );
            final topPadding = Responsive.scaledValue(
              width,
              8,
              min: 6,
              max: 14,
            );

            return Padding(
              padding: EdgeInsets.only(
                top: topPadding,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.white.withOpacity(0.2),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      SoundEffects.playClaim();
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.white.withOpacity(0.2),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      SoundEffects.playClaim();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'حدد العناصر المخالفة',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: context.findAncestorStateOfType<_LevelTwoGameScreenState>()!._counterPulse,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00695C),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${state._foundCount} / ${state._totalCount}',
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
            );
          },
        ),
      ),
    );
  }
}

// ====== مشهد المستوى (الخلفية + أماكن اللمس) ======
class _LevelTwoScene extends StatefulWidget {
  const _LevelTwoScene({
    required this.spots,
    required this.found,
    required this.onSpotTap,
    required this.designMode,
    required this.onNewRect,
  });

  final List<_ViolationSpot> spots;
  final Set<String> found;
  final ValueChanged<_ViolationSpot> onSpotTap;
  final bool designMode;
  final ValueChanged<Rect> onNewRect;

  static const double designWidth = 440;
  static const double designHeight = 956;

  @override
  State<_LevelTwoScene> createState() => _LevelTwoSceneState();
}

class _LevelTwoSceneState extends State<_LevelTwoScene> {
  Rect? _draftRect;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _LevelTwoScene.designWidth,
        height: _LevelTwoScene.designHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/LevelTwo/levelTwoBackground.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // أماكن اللمس (غير مرئية)
            ...widget.spots.map((spot) {
              final rect = Rect.fromLTWH(
                spot.area.left * _LevelTwoScene.designWidth,
                spot.area.top * _LevelTwoScene.designHeight,
                spot.area.width * _LevelTwoScene.designWidth,
                spot.area.height * _LevelTwoScene.designHeight,
              );
              final isFound = widget.found.contains(spot.id);
              return Positioned(
                left: rect.left,
                top: rect.top,
                width: rect.width,
                height: rect.height,
                child: _ViolationHitBox(
                  isFound: isFound,
                  onTap: () => widget.onSpotTap(spot),
                ),
              );
            }),

            // وضع التصميم الاختياري: رسم مستطيل وأخذ النِسَب
            if (widget.designMode)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (d) {
                    final p = d.localPosition;
                    setState(() => _draftRect = Rect.fromLTWH(p.dx, p.dy, 0, 0));
                  },
                  onPanUpdate: (d) {
                    if (_draftRect == null) return;
                    final s = _draftRect!.topLeft;
                    final c = d.localPosition;
                    final l = math.min(s.dx, c.dx);
                    final t = math.min(s.dy, c.dy);
                    final w = (c.dx - s.dx).abs();
                    final h = (c.dy - s.dy).abs();
                    setState(() => _draftRect = Rect.fromLTWH(l, t, w, h));
                  },
                  onPanEnd: (_) {
                    if (_draftRect == null) return;
                    final r = _draftRect!;
                    setState(() => _draftRect = null);
                    final normalized = Rect.fromLTWH(
                      (r.left / _LevelTwoScene.designWidth).clamp(0.0, 1.0),
                      (r.top / _LevelTwoScene.designHeight).clamp(0.0, 1.0),
                      (r.width / _LevelTwoScene.designWidth).clamp(0.0, 1.0),
                      (r.height / _LevelTwoScene.designHeight).clamp(0.0, 1.0),
                    );
                    widget.onNewRect(normalized);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomPaint(painter: _DraftRectPainter(_draftRect)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DraftRectPainter extends CustomPainter {
  final Rect? rect;
  const _DraftRectPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    if (rect == null) return;
    final fill = Paint()..color = const Color(0xFFA8443D).withOpacity(0.18);
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFFA8443D).withOpacity(0.85);
    final r = rect!;
    final rr = RRect.fromRectAndRadius(r, const Radius.circular(18));
    canvas.drawRRect(rr, fill);
    canvas.drawRRect(rr, border);
  }

  @override
  bool shouldRepaint(covariant _DraftRectPainter old) => old.rect != rect;
}

// HitBox غير مرئي، وعند الاكتشاف يظهر ✅ في الوسط
class _ViolationHitBox extends StatelessWidget {
  const _ViolationHitBox({
    required this.isFound,
    required this.onTap,
  });

  final bool isFound;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (!isFound) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: const SizedBox.expand(),
      );
    }
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E6F5C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E6F5C).withOpacity(0.55),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// كارت الشرح: شفاف جداً + Blur أعلى عشان الخلفية تبان
class _ViolationInfoCard extends StatelessWidget {
  const _ViolationInfoCard({
    required this.spot,
    required this.onDismiss,
    required this.isFirstTime,
  });

  final _ViolationSpot spot;
  final VoidCallback onDismiss;
  final bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    const double cardOpacity = 0.35;
    const double blurSigma = 16;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final mediaQuery = MediaQuery.of(context);
          final safeMinimum = Responsive.symmetricPadding(
            width,
            horizontal: 20,
            vertical: Responsive.scaledValue(
              width,
              16,
              min: 12,
              max: 28,
            ),
            maxContentWidth: Responsive.valueForWidth(
              width,
              narrow: 560,
              wide: 720,
              breakpoint: 900,
            ),
          );
          final contentHorizontal = Responsive.horizontalPadding(
            width,
            minPadding: 20,
            maxContentWidth: 600,
          );
          final topPadding = Responsive.scaledValue(
            width,
            20,
            min: 16,
            max: 28,
          );
          final bottomPadding = Responsive.scaledValue(
            width,
            16,
            min: 12,
            max: 24,
          );
          final textScale = Responsive.scaleForWidth(
            width,
            baseWidth: 390,
            minScale: 0.95,
            maxScale: 1.2,
          );

          return SafeArea(
            minimum: safeMinimum,
            child: MediaQuery(
              data: mediaQuery.copyWith(textScaleFactor: textScale),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Dismissible(
                      key: ValueKey(spot.id),
                      direction: DismissDirection.down,
                      onDismissed: (_) => onDismiss(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: blurSigma,
                            sigmaY: blurSigma,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              contentHorizontal,
                              topPadding,
                              contentHorizontal,
                              bottomPadding,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(cardOpacity),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.45),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 14,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: onDismiss,
                            icon: const Icon(Icons.close_rounded),
                            color: const Color(0xFF2F2F2F),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  spot.title,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1E6F5C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isFirstTime
                                      ? 'أحسنت! لقد اكتشفت تشوهاً بصرياً.'
                                      : 'هذا شرح العنصر الذي اخترته.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF3F3F3F),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E6F5C).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF1E6F5C),
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        spot.description,
                        style: textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: const Color(0xFF2B2B2B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E6F5C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: onDismiss,
                          child: Text(
                            isFirstTime ? 'تابع البحث' : 'إغلاق',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                          ),
                        ),
                      ),
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

/// لمعات (Flashes) على كل منطقة بالتتابع — بدون Glare وبدون تبديل الصورة داخل المستطيلات
class _SequentialSpotFlashes extends StatelessWidget {
  const _SequentialSpotFlashes({
    required this.progress,
    required this.spots,
    required this.designWidth,
    required this.designHeight,
  });

  final Animation<double> progress;
  final List<_ViolationSpot> spots;
  final double designWidth;
  final double designHeight;

  @override
  Widget build(BuildContext context) {
    final n = spots.length;
    const per = 1.0; // نقسم الزمن بالتساوي على كل Spot

    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final p = progress.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            // الخلفية الأصلية تظل كما هي (لا تبديل للصور هنا)
            // flashes فقط
            ...List.generate(n, (i) {
              final start = (per / n) * i;
              final end = start + (per / n);
              final t = ((p - start) / (end - start)).clamp(0.0, 1.0);

              final area = spots[i].area;
              final rect = Rect.fromLTWH(
                area.left * designWidth,
                area.top * designHeight,
                area.width * designWidth,
                area.height * designHeight,
              );

              // منحنى لمعان بسيط: يظهر ويختفي سريعاً مع Scale خفيف
              final opacity = Curves.easeInOut.transform(t);
              final scale = lerpDouble(0.9, 1.05, Curves.easeOut.transform(t))!;

              return Positioned(
                left: rect.left,
                top: rect.top,
                width: rect.width,
                height: rect.height,
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // لمعة خفيفة شبه بيضاء
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.35),
                            Colors.white.withOpacity(0.15),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.35),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

/// glare كامل على الشاشة (مع إدخال الصورة النهائية)
class _FullScreenGlare extends StatelessWidget {
  const _FullScreenGlare({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Transform.rotate(
        angle: -0.35,
        child: FractionalTranslation(
          translation: Offset(lerpDouble(-1.2, 1.2, progress)!, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.55),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== الموديل =====
class _ViolationSpot {
  const _ViolationSpot({
    required this.id,
    required this.area, // normalized (0..1)
    required this.title,
    required this.description,
  });

  final String id;
  final Rect area;
  final String title;
  final String description;
}
