import 'package:flutter/material.dart';
import 'package:flutter_chart/src/models/label/label_box_style.dart';
import 'package:flutter_chart/src/models/line/line_style.dart';
import 'package:flutter_chart/src/models/path/path_style.dart';
import 'package:flutter_chart/src/models/point/point_style.dart';

/// Line chart theme
class LineTheme {
  /// Path style
  final PathStyle pathStyle;

  /// Line style
  final LineStyle lineStyle;

  /// Point style
  final PointStyle pointStyle;

  /// Highlighted point style
  final PointStyle highlightedPointStyle;

  /// Label box style
  final LabelBoxStyle labelBoxStyle;

  const LineTheme({
    this.pathStyle = const PathStyle(color: Colors.blue),
    this.lineStyle = const LineStyle(),
    this.pointStyle = const PointStyle(),
    this.highlightedPointStyle = const PointStyle(),
    this.labelBoxStyle = const LabelBoxStyle(),
  });
}
