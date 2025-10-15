import 'dart:ui';

import 'package:flutter/material.dart';

import 'level_completion_screen.dart';

class LevelTwoGameScreen extends StatefulWidget {
  const LevelTwoGameScreen({super.key});

  @override
  State<LevelTwoGameScreen> createState() => _LevelTwoGameScreenState();
}

class _LevelTwoGameScreenState extends State<LevelTwoGameScreen> {
  final List<_ViolationSpot> _spots = const [
    _ViolationSpot(
      id: 'kite',
      area: Rect.fromLTWH(0.24, 0.03, 0.22, 0.15),
      title: 'طائرة ورقية عالقة',
      description: 'ترك الطائرة الورقية عالقة في المبنى يشوّه المنظر العام وقد يتسبب في تلف السطح.',
    ),
    _ViolationSpot(
      id: 'looseFence',
      area: Rect.fromLTWH(0.56, 0.09, 0.24, 0.12),
      title: 'سياج غير مثبت',
      description: 'السياج الخشبي المائل فوق السطح غير آمن ويعطي انطباعاً بالإهمال.',
    ),
    _ViolationSpot(
      id: 'satelliteDish',
      area: Rect.fromLTWH(0.1, 0.25, 0.22, 0.11),
      title: 'طبق استقبال مائل',
      description: 'الأطباق المثبتة بشكل عشوائي على الواجهات تسبب خطراً بصرياً وقد تسقط.',
    ),
    _ViolationSpot(
      id: 'graffitiLeft',
      area: Rect.fromLTWH(0.24, 0.38, 0.18, 0.08),
      title: 'كتابة على الجدار',
      description: 'الكتابة العشوائية على الجدران تعد تشوهاً بصرياً وتخالف الذوق العام.',
    ),
    _ViolationSpot(
      id: 'graffitiRight',
      area: Rect.fromLTWH(0.62, 0.41, 0.2, 0.08),
      title: 'ملصق مخالف',
      description: 'تعليق الملصقات الإعلانية دون إذن يشوه واجهة المبنى.',
    ),
    _ViolationSpot(
      id: 'acLeft',
      area: Rect.fromLTWH(0.24, 0.51, 0.2, 0.11),
      title: 'مكيف مكشوف',
      description: 'المكيف الموضوع دون غطاء يحجب جمال الواجهة وقد يتسرب منه الماء.',
    ),
    _ViolationSpot(
      id: 'acRight',
      area: Rect.fromLTWH(0.56, 0.51, 0.2, 0.11),
      title: 'مكيف بحاجة لصيانة',
      description: 'عدم صيانة أجهزة التكييف الخارجية يظهر أسلاكاً متدلية ويشوه المنظر.',
    ),
    _ViolationSpot(
      id: 'sign',
      area: Rect.fromLTWH(0.66, 0.7, 0.2, 0.15),
      title: 'لافتة متضررة',
      description: 'اللافتة الباهتة والمكسورة تقلل من جاذبية المحل وتخالف اللوائح.',
    ),
    _ViolationSpot(
      id: 'numberPlate',
      area: Rect.fromLTWH(0.38, 0.63, 0.22, 0.08),
      title: 'لوحة رقم غير واضحة',
      description: 'ترك لوحة العنوان متسخة أو مائلة يصعب قراءة الرقم ويشوه المظهر.',
    ),
    _ViolationSpot(
      id: 'storeClutter',
      area: Rect.fromLTWH(0.14, 0.73, 0.22, 0.16),
      title: 'مدخل غير منظم',
      description: 'تكدس الأدوات أمام المحل يمنع المرور ويعطي انطباعاً بالفوضى.',
    ),
  ];

  final Set<String> _found = <String>{};
  _ViolationSpot? _activeSpot;
  bool _lastTapWasNew = false;
  bool _completionShown = false;

  int get _foundCount => _found.length;
  int get _totalCount => _spots.length;
  bool get _allFound => _foundCount == _totalCount;

  void _handleSpotTap(_ViolationSpot spot) {
    final alreadyFound = _found.contains(spot.id);

    setState(() {
      _found.add(spot.id);
      _activeSpot = spot;
      _lastTapWasNew = !alreadyFound;
    });
  }

  void _handleCloseInfo() {
    setState(() {
      _activeSpot = null;
    });

    if (_allFound && !_completionShown) {
      _completionShown = true;
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LevelCompletionScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _LevelTwoScene(
            spots: _spots,
            found: _found,
            onSpotTap: _handleSpotTap,
          ),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.white.withOpacity(0.2),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'حدد العناصر المخالفة',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00695C),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '$_foundCount / $_totalCount',
                                  style: textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'اضغط على كل عنصر مخالف لتتعرف على سبب كونه تشوهاً بصرياً.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_activeSpot != null)
            _ViolationInfoCard(
              spot: _activeSpot!,
              onDismiss: _handleCloseInfo,
              isFirstTime: _lastTapWasNew,
            ),
        ],
      ),
    );
  }
}

class _LevelTwoScene extends StatelessWidget {
  const _LevelTwoScene({
    required this.spots,
    required this.found,
    required this.onSpotTap,
  });

  static const double _designWidth = 440;
  static const double _designHeight = 956;

  final List<_ViolationSpot> spots;
  final Set<String> found;
  final ValueChanged<_ViolationSpot> onSpotTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _designWidth,
            height: _designHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/LevelTwo/levelTwoBackground.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                ...spots.map((spot) {
                  final rect = Rect.fromLTWH(
                    spot.area.left * _designWidth,
                    spot.area.top * _designHeight,
                    spot.area.width * _designWidth,
                    spot.area.height * _designHeight,
                  );
                  final isFound = found.contains(spot.id);

                  return Positioned(
                    left: rect.left,
                    top: rect.top,
                    width: rect.width,
                    height: rect.height,
                    child: _ViolationHitBox(
                      isFound: isFound,
                      onTap: () => onSpotTap(spot),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViolationHitBox extends StatelessWidget {
  const _ViolationHitBox({
    required this.isFound,
    required this.onTap,
  });

  final bool isFound;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isFound) {
      return Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E6F5C).withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFA8443D).withOpacity(0.85),
              width: 2,
            ),
            color: const Color(0xFFA8443D).withOpacity(0.18),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Dismissible(
            key: ValueKey(spot.id),
            direction: DismissDirection.down,
            onDismissed: (_) => onDismiss(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E6F5C).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          isFirstTime ? Icons.check_circle_outline : Icons.info_outline,
                          color: const Color(0xFF1E6F5C),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                                color: const Color(0xFF4A4A4A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onDismiss,
                        icon: const Icon(Icons.close_rounded),
                        color: const Color(0xFF4A4A4A),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    spot.description,
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: const Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
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
    );
  }
}

class _ViolationSpot {
  const _ViolationSpot({
    required this.id,
    required this.area,
    required this.title,
    required this.description,
  });

  final String id;
  final Rect area;
  final String title;
  final String description;
}
