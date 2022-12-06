import 'package:flutter_chart/flutter_chart.dart';

/// Line.
class Line {
  /// List of points.
  final List<ChartPoint> points;

  /// Line theme.
  final LineTheme theme;

  /// Highlighted point.
  final ChartPoint? highlightedPoint;

  /// Should draw labels.
  final bool shouldDrawLabels;

  /// Should draw line.
  final bool shouldDrawLine;

  /// Should draw path.
  final bool shouldDrawPath;

  /// Should draw points.
  final bool shouldDrawPoints;

  /// Should draw highlighted point.
  final bool shouldDrawHighlightedPoint;

  const Line({
    required this.points,
    this.theme = const LineTheme(),
    this.highlightedPoint,
    this.shouldDrawLabels = true,
    this.shouldDrawLine = true,
    this.shouldDrawPath = true,
    this.shouldDrawPoints = true,
    this.shouldDrawHighlightedPoint = true,
  });

  /// Copy with.
  Line copyWith(
      {List<ChartPoint>? points,
      LineTheme? theme,
      ChartPoint? highlightedPoint,
      bool? shouldDrawLabels,
      bool? shouldDrawLine,
      bool? shouldDrawPath,
      bool? shouldDrawPoints,
      bool? shouldDrawHighlightedPoint,
      bool forceNullHighlightedPoint = false}) {
    return Line(
      points: points ?? this.points,
      theme: theme ?? this.theme,
      highlightedPoint: forceNullHighlightedPoint
          ? null
          : highlightedPoint ?? this.highlightedPoint,
      shouldDrawLabels: shouldDrawLabels ?? this.shouldDrawLabels,
      shouldDrawLine: shouldDrawLine ?? this.shouldDrawLine,
      shouldDrawPath: shouldDrawPath ?? this.shouldDrawPath,
      shouldDrawPoints: shouldDrawPoints ?? this.shouldDrawPoints,
      shouldDrawHighlightedPoint:
          shouldDrawHighlightedPoint ?? this.shouldDrawHighlightedPoint,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Line &&
          runtimeType == other.runtimeType &&
          points == other.points &&
          theme == other.theme &&
          highlightedPoint == other.highlightedPoint &&
          shouldDrawLabels == other.shouldDrawLabels &&
          shouldDrawLine == other.shouldDrawLine &&
          shouldDrawPath == other.shouldDrawPath &&
          shouldDrawPoints == other.shouldDrawPoints &&
          shouldDrawHighlightedPoint == other.shouldDrawHighlightedPoint;

  @override
  int get hashCode =>
      points.hashCode &
      theme.hashCode &
      highlightedPoint.hashCode &
      shouldDrawLabels.hashCode &
      shouldDrawLine.hashCode &
      shouldDrawPath.hashCode &
      shouldDrawPoints.hashCode &
      shouldDrawHighlightedPoint.hashCode;
}

/// extension on List<Line>.
extension NewList on List<Line> {
  /// Copy with.
  List<Line> copyWith(
      {List<ChartPoint>? points,
      LineTheme? theme,
      ChartPoint? highlightedPoint,
      bool? shouldDrawLabels,
      bool? shouldDrawLine,
      bool? shouldDrawPath,
      bool? shouldDrawPoints,
      bool? shouldDrawHighlightedPoint}) {
    return map((line) => line.copyWith(
        points: points,
        theme: theme,
        highlightedPoint: highlightedPoint,
        shouldDrawLabels: shouldDrawLabels,
        shouldDrawLine: shouldDrawLine,
        shouldDrawPath: shouldDrawPath,
        shouldDrawPoints: shouldDrawPoints,
        shouldDrawHighlightedPoint: shouldDrawHighlightedPoint)).toList();
  }
}
