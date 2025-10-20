import 'dart:math' as math;

/// Utility helpers for building responsive UIs across different screen sizes.
///
/// The app was originally designed against mobile breakpoints. These helpers
/// allow us to scale a handful of measurements so that the layout can breathe
/// on phones while also expanding gracefully on larger devices such as
/// tablets and desktop windows.
class Responsive {
  const Responsive._();

  /// Clamps [value] between [min] and [max].
  static double clamp(double value, double min, double max) {
    assert(min <= max, 'The minimum boundary must be smaller than the maximum');
    return math.min(max, math.max(min, value));
  }

  /// Returns a width-aware scale factor based on the provided [width].
  ///
  /// [baseWidth] represents the original design width. The calculated scale is
  /// clamped between [minScale] and [maxScale] to avoid tiny or oversized UI.
  static double scaleForWidth(
    double width, {
    double baseWidth = 375,
    double minScale = 0.85,
    double maxScale = 1.35,
  }) {
    final scale = width / baseWidth;
    return clamp(scale, minScale, maxScale);
  }

  /// Picks a value depending on the available [width].
  ///
  /// Useful when a widget needs to jump between a couple of discrete sizes
  /// once the screen reaches tablet breakpoints.
  static T valueForWidth<T>(
    double width, {
    required T narrow,
    required T wide,
    double breakpoint = 600,
  }) {
    return width >= breakpoint ? wide : narrow;
  }
}
