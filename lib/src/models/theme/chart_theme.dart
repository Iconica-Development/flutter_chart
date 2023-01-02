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

  const ChartTheme({
    this.xAxisHeight = 30,
    this.yAxisWidth = 30,
    this.axisBuilder,
    this.rasterStyle = const RasterStyle(),
  });
}
