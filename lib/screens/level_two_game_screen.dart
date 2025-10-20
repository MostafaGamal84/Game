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
    final screenSize = MediaQuery.of(context).size;
    final screenScale = Responsive.scaleForWidth(
      screenSize.width,
      baseWidth: 390,
      minScale: 0.85,
      maxScale: 1.35,
    );
    final bottomPadding = Responsive.clamp(20 * screenScale, 16, 40);
    final bottomHorizontalPadding = Responsive.clamp(20 * screenScale, 16, 48);
    final bottomButtonWidth = Responsive.clamp(screenSize.width * 0.6, 240, 520);
    final bottomButtonPadding = Responsive.clamp(14 * screenScale, 12, 22);
    final bottomButtonRadius = Responsive.clamp(18 * screenScale, 16, 30);
    final bottomButtonFontSize = Responsive.clamp(20 * screenScale, 16, 28);

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
          if (!_playFinish)
            _TopHud(
              foundCount: _foundCount,
              totalCount: _totalCount,
              counterPulse: _counterPulse,
            ),

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
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    bottomHorizontalPadding,
                    0,
                    bottomHorizontalPadding,
                    bottomPadding,
                  ),
                  child: SizedBox(
                    width: bottomButtonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E6F5C),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: bottomButtonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(bottomButtonRadius),
                        ),
                      ),
                      onPressed: _goToCompletion,
                      child: Text(
                        'متابعة',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: bottomButtonFontSize,
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

/// HUD مثبت أعلى الشاشة
class _TopHud extends StatelessWidget {
  const _TopHud({
    super.key,
    required this.foundCount,
    required this.totalCount,
    required this.counterPulse,
  });

  final int foundCount;
  final int totalCount;
  final double counterPulse;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = Responsive.scaleForWidth(
      screenWidth,
      baseWidth: 390,
      minScale: 0.85,
      maxScale: 1.3,
    );
    final horizontalPadding = Responsive.clamp(12 * scale, 8, 20);
    final verticalPadding = Responsive.clamp(8 * scale, 6, 16);
    final iconSize = Responsive.clamp(24 * scale, 20, 32);
    final titleFontSize = Responsive.clamp(18 * scale, 14, 24);
    final counterPaddingH = Responsive.clamp(18 * scale, 12, 28);
    final counterPaddingV = Responsive.clamp(8 * scale, 6, 14);
    final counterFontSize = Responsive.clamp(20 * scale, 16, 28);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: verticalPadding,
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
                    child: Padding(
                      padding: EdgeInsets.all(Responsive.clamp(10 * scale, 8, 14)),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: iconSize,
                      ),
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
                    child: Padding(
                      padding: EdgeInsets.all(Responsive.clamp(10 * scale, 8, 14)),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: iconSize,
                      ),
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
                      fontSize: titleFontSize,
                    ),
                  ),
                  SizedBox(height: Responsive.clamp(6 * scale, 4, 10)),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: counterPulse,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: counterPaddingH,
                        vertical: counterPaddingV,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00695C),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: Responsive.clamp(10 * scale, 6, 16),
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '$foundCount / $totalCount',
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: Responsive.clamp(2 * scale, 1, 3),
                          fontSize: counterFontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = Responsive.scaleForWidth(
      screenWidth,
      baseWidth: 390,
      minScale: 0.85,
      maxScale: 1.3,
    );

    const double cardOpacity = 0.35;
    const double blurSigma = 16;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        minimum: EdgeInsets.symmetric(
          horizontal: Responsive.clamp(20 * scale, 14, 36),
          vertical: Responsive.clamp(16 * scale, 12, 28),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Dismissible(
            key: ValueKey(spot.id),
            direction: DismissDirection.down,
            onDismissed: (_) => onDismiss(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Responsive.clamp(24 * scale, 18, 36)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.clamp(20 * scale, 16, 32),
                    Responsive.clamp(20 * scale, 16, 32),
                    Responsive.clamp(20 * scale, 16, 32),
                    Responsive.clamp(16 * scale, 12, 28),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(cardOpacity),
                    borderRadius: BorderRadius.circular(Responsive.clamp(24 * scale, 18, 36)),
                    border: Border.all(color: Colors.white.withOpacity(0.45)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: Responsive.clamp(14 * scale, 10, 22),
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
                            icon: Icon(
                              Icons.close_rounded,
                              size: Responsive.clamp(24 * scale, 20, 32),
                            ),
                            color: const Color(0xFF2F2F2F),
                          ),
                          SizedBox(width: Responsive.clamp(8 * scale, 6, 14)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  spot.title,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1E6F5C),
                                    fontSize:
                                        Responsive.clamp((textTheme.titleLarge?.fontSize ?? 24) * scale, 18, 30),
                                  ),
                                ),
                                SizedBox(height: Responsive.clamp(4 * scale, 2, 8)),
                                Text(
                                  isFirstTime
                                      ? 'أحسنت! لقد اكتشفت تشوهاً بصرياً.'
                                      : 'هذا شرح العنصر الذي اخترته.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF3F3F3F),
                                    fontWeight: FontWeight.w600,
                                    fontSize: Responsive.clamp(
                                      (textTheme.bodyMedium?.fontSize ?? 16) * scale,
                                      14,
                                      22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Responsive.clamp(8 * scale, 6, 14)),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E6F5C).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(Responsive.clamp(10 * scale, 8, 16)),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF1E6F5C),
                              size: Responsive.clamp(26 * scale, 20, 34),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.clamp(12 * scale, 8, 20)),
                      Text(
                        spot.description,
                        style: textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: const Color(0xFF2B2B2B),
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.clamp(
                            (textTheme.bodyLarge?.fontSize ?? 18) * scale,
                            16,
                            26,
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.clamp(14 * scale, 10, 22)),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E6F5C),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.clamp(14 * scale, 12, 22),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.clamp(18 * scale, 14, 28),
                              ),
                            ),
                          ),
                          onPressed: onDismiss,
                          child: Text(
                            isFirstTime ? 'تابع البحث' : 'إغلاق',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: Responsive.clamp(
                                (textTheme.titleMedium?.fontSize ?? 20) * scale,
                                16,
                                26,
                              ),
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
