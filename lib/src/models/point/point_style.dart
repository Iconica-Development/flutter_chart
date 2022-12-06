import 'package:flutter/material.dart';
import 'package:flutter_chart/src/models/point/point_shape.dart';

/// Point style
class PointStyle {
  /// Point color
  final Color? color;

  /// Point size
  final double? size;

  /// Point shape
  final PointShape? shape;

  const PointStyle({
    this.color = Colors.blue,
    this.size = 10,
    this.shape = PointShape.circle,
  });
}
