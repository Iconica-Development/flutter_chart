import 'package:flutter/material.dart';
import 'package:flutter_chart/src/models/line/line_form.dart';

/// Line style
class LineStyle {
  /// Line color
  final Color color;

  /// Line stroke width
  final double strokeWidth;

  /// Line form
  final LineForm lineForm;

  const LineStyle({
    this.color = Colors.blue,
    this.strokeWidth = 2,
    this.lineForm = LineForm.straight,
  });
}
