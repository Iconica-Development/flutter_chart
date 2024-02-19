import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';
import 'package:flutter_chart/src/chart/line_chart/painter.dart';

class LineChart extends StatefulWidget {
  /// Constructs a `LineChart` widget.
  ///
  /// [lines]: The list of lines to be displayed on the chart.
  /// [height]: The height of the chart.
  /// [width]: The width of the chart.
  /// [chartTheme]: The theme configuration for the chart. Defaults to [ChartTheme()].
  /// [maxX]: The maximum value for the X-axis.
  /// [maxY]: The maximum value for the Y-axis.
  /// [shouldDrawRaster]: Whether to draw raster on the chart. Defaults to `true`.
  /// [labelDetectionZone]: The zone around data points where hover events are detected. Defaults to `10`.
  const LineChart({
    required this.lines,
    required this.height,
    required this.width,
    this.chartTheme = const ChartTheme(),
    this.maxX,
    this.maxY,
    this.shouldDrawRaster = true,
    this.labelDetectionZone = 10,
    super.key,
  });

  final List<Line> lines;
  final ChartTheme chartTheme;
  final double? maxX;
  final double? maxY;
  final bool shouldDrawRaster;
  final int labelDetectionZone;
  final double height;
  final double width;

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<Size> textSizes = [];
  late List<Line> lines;

  @override
  void initState() {
    super.initState();
    lines = widget.lines;
    if (textSizes.isEmpty) {
      textSizes = List.generate(
        (widget.maxX ?? widget.width.toInt()).toString().length,
        (index) => calculateTextSize(
          '0' * (index + 1),
          widget.chartTheme.axisTextStyle ?? const TextStyle(fontSize: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var horizontalGap = (widget.width -
            widget.chartTheme.yAxisWidth -
            textSizes[(widget.maxX?.toInt().toString().length ??
                            widget.width.toInt().toString().length) -
                        1]
                    .width /
                2) /
        widget.chartTheme.rasterStyle.horizontalGaps;
    var graphHeight = (widget.chartTheme.axisBuilder != null &&
                widget.chartTheme.axisBuilder!.xAxisBuilder != null
            ? widget.height - widget.chartTheme.xAxisHeight
            : widget.height) -
        textSizes.first.height / 2;
    var graphWidth = (widget.chartTheme.axisBuilder != null &&
                widget.chartTheme.axisBuilder!.yAxisBuilder != null
            ? widget.width - widget.chartTheme.yAxisWidth
            : widget.width) -
        ((widget.chartTheme.axisBuilder?.xAxisBuilder!(context, 0, 0).$2 ??
                textSizes.first.width) /
            2);
    var verticalGap = graphHeight / widget.chartTheme.rasterStyle.verticalGaps;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.chartTheme.axisBuilder != null &&
            widget.chartTheme.axisBuilder!.yAxisBuilder != null) ...[
          SizedBox(
            width: max(
                widget.chartTheme.yAxisWidth -
                    ((widget.chartTheme.axisBuilder
                                ?.xAxisBuilder!(context, 0, 0).$2 ??
                            textSizes.first.width) /
                        2),
                0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = widget.chartTheme.rasterStyle.verticalGaps.toInt();
                    i >= 0;
                    i--) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      top: i ==
                              widget.chartTheme.rasterStyle.verticalGaps.toInt()
                          ? 0
                          : graphHeight /
                                  widget.chartTheme.rasterStyle.verticalGaps
                                      .toInt() -
                              textSizes.first.height,
                      right: widget.chartTheme.yAxisPaddingRight,
                    ),
                    child: SizedBox(
                      width: max(
                          widget.chartTheme.yAxisWidth -
                              widget.chartTheme.yAxisPaddingRight -
                              ((widget.chartTheme.axisBuilder
                                          ?.xAxisBuilder!(context, 0, 0).$2 ??
                                      textSizes.first.width) /
                                  2),
                          0),
                      child: widget
                          .chartTheme
                          .axisBuilder!
                          .yAxisBuilder!(
                        context,
                        i,
                        (widget.maxY ?? widget.height) /
                            widget.chartTheme.rasterStyle.verticalGaps *
                            i,
                      )
                          .$1,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: textSizes.first.height / 2,
                left: ((widget.chartTheme.axisBuilder
                            ?.xAxisBuilder!(context, 0, 0).$2 ??
                        textSizes.first.width) /
                    2),
              ),
              width: graphWidth,
              height: graphHeight,
              child: MouseRegion(
                onHover: (event) =>
                    _onHover(event, Size(graphWidth, graphHeight)),
                child: ClipRRect(
                  child: CustomPaint(
                    painter: LineChartPainter(
                      lines: lines,
                      rasterStyle: widget.chartTheme.rasterStyle,
                      maxX: widget.maxX,
                      maxY: widget.maxY,
                      shouldDrawRaster: widget.shouldDrawRaster,
                      horizontalGap: horizontalGap,
                      verticalGap: verticalGap,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.chartTheme.axisBuilder != null &&
                widget.chartTheme.axisBuilder!.xAxisBuilder != null) ...[
              Container(
                margin: EdgeInsets.only(
                  top: max(
                    widget.chartTheme.xAxisHeight - textSizes.first.height,
                    0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var i = 0;
                        i <= widget.chartTheme.rasterStyle.horizontalGaps;
                        i++) ...[
                      Padding(
                        padding: EdgeInsets.only(
                          right: i ==
                                  widget.chartTheme.rasterStyle.horizontalGaps
                              ? 0
                              : horizontalGap -
                                  ((widget
                                                  .chartTheme
                                                  .axisBuilder!
                                                  .xAxisBuilder!(
                                                context,
                                                i,
                                                (widget.maxX ?? widget.width) /
                                                    widget
                                                        .chartTheme
                                                        .rasterStyle
                                                        .horizontalGaps *
                                                    i,
                                              )
                                                  .$2 ??
                                              textSizes[((widget.maxX ??
                                                                  widget
                                                                      .width) /
                                                              widget
                                                                  .chartTheme
                                                                  .rasterStyle
                                                                  .horizontalGaps *
                                                              i)
                                                          .floor()
                                                          .toString()
                                                          .length -
                                                      1]
                                                  .width) /
                                          2
                                      // number we are at

                                      +
                                      (widget
                                                  .chartTheme
                                                  .axisBuilder!
                                                  .xAxisBuilder!(
                                                context,
                                                i + 1,
                                                (widget.maxX ?? widget.width) /
                                                    widget
                                                        .chartTheme
                                                        .rasterStyle
                                                        .horizontalGaps *
                                                    (i + 1),
                                              )
                                                  .$2 ??
                                              textSizes[((widget.maxX ??
                                                                  widget
                                                                      .width) /
                                                              widget
                                                                  .chartTheme
                                                                  .rasterStyle
                                                                  .horizontalGaps *
                                                              (i + 1))
                                                          .floor()
                                                          .toString()
                                                          .length -
                                                      1]
                                                  .width) /
                                          2
                                  // number we are going to

                                  ),
                        ),
                        child: widget
                            .chartTheme
                            .axisBuilder!
                            .xAxisBuilder!(
                          context,
                          i,
                          (widget.maxX ?? widget.width) /
                              widget.chartTheme.rasterStyle.horizontalGaps *
                              i,
                        )
                            .$1,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
        // another y axis
        if (widget.chartTheme.axisBuilder != null &&
            widget.chartTheme.axisBuilder!.secondaryYAxisBuilder != null) ...[
          SizedBox(
            width: max(
                widget.chartTheme.secondaryYAxisWidth -
                    ((widget.chartTheme.axisBuilder
                                ?.xAxisBuilder!(context, 0, 0).$2 ??
                            textSizes.first.width) /
                        2),
                0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = widget.chartTheme.rasterStyle.verticalGaps.toInt();
                    i >= 0;
                    i--) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      top: i ==
                              widget.chartTheme.rasterStyle.verticalGaps.toInt()
                          ? 0
                          : graphHeight /
                                  widget.chartTheme.rasterStyle.verticalGaps
                                      .toInt() -
                              textSizes.first.height,
                      left: widget.chartTheme.secondaryYAxisPaddingLeft,
                    ),
                    child: SizedBox(
                      width: max(
                          widget.chartTheme.secondaryYAxisWidth -
                              widget.chartTheme.secondaryYAxisPaddingLeft -
                              ((widget.chartTheme.axisBuilder
                                          ?.xAxisBuilder!(context, 0, 0).$2 ??
                                      textSizes.first.width) /
                                  2),
                          0),
                      child: widget
                          .chartTheme
                          .axisBuilder!
                          .secondaryYAxisBuilder!(
                        context,
                        i,
                        (widget.maxY ?? widget.height) /
                            widget.chartTheme.rasterStyle.verticalGaps *
                            i,
                      )
                          .$1,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _onHover(PointerHoverEvent event, Size chartArea) {
    ChartPoint? point;
    for (var line in lines) {
      point = line.points.firstWhere(
        (point) {
          // calculate the X and Y coordinates of the point
          final Offset translatedPoint = point.translatedCoordinatesWithMax(
              chartArea.height,
              chartArea.width,
              widget.maxX ?? chartArea.height,
              widget.maxY ?? chartArea.width);
          var pointSize = line.theme.pointStyle.size ?? 10;
          var pointerRadius = (pointSize / 2);
          var maximumDistance = pointerRadius + widget.labelDetectionZone;
          // check if the point is within the detection zone of the event
          return (event.localPosition.dx - translatedPoint.dx).abs() <=
                  maximumDistance &&
              (event.localPosition.dy - translatedPoint.dy).abs() <=
                  maximumDistance;
        },
        orElse: () => const ChartPoint(double.infinity, double.infinity),
      );
      // remove the highlight from all lines except but store the point that was found
      if (point.x != double.infinity && point.y != double.infinity) {
        setState(() {
          lines = lines.map((e) {
            if (e.points.contains(point)) {
              return e.copyWith(highlightedPoint: point);
            }
            return e.copyWith(highlightedPoint: null);
          }).toList();
        });
        break;
      }
    }

    // remove the highlight from all lines except the one that contains the point
    // this is to make sure that the line resets when the mouse leaves the detection zone
    setState(() {
      lines = lines.map((e) {
        if (e.highlightedPoint == point) {
          return e;
        }
        return e.copyWith(
            highlightedPoint: null, forceNullHighlightedPoint: true);
      }).toList();
    });
  }
}

Size calculateTextSize(String text, TextStyle style) {
  return (TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout())
      .size;
}
