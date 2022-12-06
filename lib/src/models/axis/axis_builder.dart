import 'package:flutter/material.dart';

/// [IndexedValueWidgetBuilder] is a typedef that allows you to customize the axis.
typedef IndexedValueWidgetBuilder = Widget Function(
    BuildContext context, int index, double value);

/// [AxisBuilder] is a class that allows you to customize the axis.
class AxisBuilder {
  /// [xAxisBuilder] is a function that allows you to customize the x axis using [IndexedValueWidgetBuilder].
  final IndexedValueWidgetBuilder? xAxisBuilder;

  /// [yAxisBuilder] is a function that allows you to customize the y axis using [IndexedValueWidgetBuilder].
  final IndexedValueWidgetBuilder? yAxisBuilder;

  const AxisBuilder({
    this.xAxisBuilder,
    this.yAxisBuilder,
  });
}
