import 'package:flutter_chart/src/models/axis/axis_builder.dart';
import 'package:flutter_chart/src/models/raster/raster_style.dart';

/// Chart theme
class ChartTheme {
  /// Axis builder
  final AxisBuilder? axisBuilder;

  /// Raster style
  final RasterStyle rasterStyle;

  const ChartTheme({
    this.axisBuilder,
    this.rasterStyle = const RasterStyle(),
  });
}
