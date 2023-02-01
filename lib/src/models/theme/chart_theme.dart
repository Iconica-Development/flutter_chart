import 'package:flutter/material.dart';
import 'package:flutter_chart/src/models/axis/axis_builder.dart';
import 'package:flutter_chart/src/models/raster/raster_style.dart';

/// Chart theme
class ChartTheme {
  /// Axis builder
  final AxisBuilder? axisBuilder;

  /// Raster style
  final RasterStyle rasterStyle;

  /// The height of the xAxis where the labels are drawn
  final double xAxisHeight;

  /// The width of the yAxis where the labels are drawn
  final double yAxisWidth;

  /// The padding right of the yAxis where the labels are drawn
  final double yAxisPaddingRight;

  /// Axis text style used for calculating the size of the labels
  final TextStyle? axisTextStyle;

  const ChartTheme({
    this.xAxisHeight = 30,
    this.yAxisWidth = 30,
    this.yAxisPaddingRight = 0,
    this.axisBuilder,
    this.axisTextStyle,
    this.rasterStyle = const RasterStyle(),
  });
}
