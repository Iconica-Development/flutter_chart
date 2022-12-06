import 'package:flutter/material.dart';

/// Path style.
class PathStyle {
  /// Path color.
  final Color? color;

  /// Path gradient.
  final Gradient? gradient;

  const PathStyle({
    this.color,
    this.gradient,
  }) : assert((gradient != null && color == null) ||
            (gradient == null && color != null));
}
