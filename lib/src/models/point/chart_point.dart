import 'package:flutter/material.dart';

/// Chart point.
@immutable
class ChartPoint {
  /// X coordinate.
  final double x;

  /// Y coordinate.
  final double y;

  /// Label.
  final String? label;

  const ChartPoint(
    this.x,
    this.y, {
    this.label,
  });

  /// Translates the coordinates to the [Offset] using the [height] and [width].
  Offset translatedCoordinatesWithMax(
    double height,
    double width,
    double maxX,
    double maxY,
  ) {
    return Offset(
      x * (width / maxX),
      height - (y * (height / maxY)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartPoint &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          label == other.label;

  @override
  int get hashCode => x.hashCode & y.hashCode & label.hashCode;

  ChartPoint copyWith({
    double? x,
    double? y,
    String? label,
  }) {
    return ChartPoint(
      x ?? this.x,
      y ?? this.y,
      label: label ?? this.label,
    );
  }
}
