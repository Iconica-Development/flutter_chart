import 'package:flutter/material.dart';
import 'package:flutter_chart/src/models/raster/raster_type.dart';

/// Raster style
class RasterStyle {
  /// Raster color
  final Color color;

  /// Raster horizontalGaps
  final double horizontalGaps;

  /// Raster verticalGaps, this should be the same as the amount of labels in the yAxis to preserve alignment
  final double verticalGaps;

  /// Raster stroke width
  final double strokeWidth;

  /// Raster type
  final RasterType rasterType;

  const RasterStyle({
    this.color = Colors.grey,
    this.verticalGaps = 10,
    this.horizontalGaps = 10,
    this.strokeWidth = 1,
    this.rasterType = RasterType.horizontal,
  });
}
