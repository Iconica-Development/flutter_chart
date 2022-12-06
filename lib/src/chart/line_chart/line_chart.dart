import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';
import 'package:flutter_chart/src/chart/line_chart/painter.dart';

const int kAxis = 30;

class LineChart extends StatefulWidget {
  const LineChart({
    super.key,
    required this.lines,
    required this.height,
    required this.width,
    this.chartTheme = const ChartTheme(),
    this.maxX,
    this.maxY,
    this.shouldDrawRaster = true,
    this.labelDetectionZone = 10,
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
          const TextStyle(fontSize: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var horizontalGap = (widget.width -
            kAxis -
            textSizes[(widget.maxX?.toInt().toString().length ??
                            widget.width.toInt().toString().length) -
                        1]
                    .width /
                2) /
        widget.chartTheme.rasterStyle.horizontalGaps;

    var verticalGap =
        (widget.height - kAxis) / widget.chartTheme.rasterStyle.verticalGaps;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.chartTheme.axisBuilder != null &&
            widget.chartTheme.axisBuilder!.yAxisBuilder != null)
          SizedBox(
            height: widget.height,
            width: max(kAxis - textSizes.first.width / 2, 0),
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
                          : verticalGap - textSizes.first.height,
                      right: 10,
                    ),
                    child: SizedBox(
                      width: max(kAxis - textSizes.first.width / 2, 0),
                      child: widget.chartTheme.axisBuilder!.yAxisBuilder!(
                        context,
                        i,
                        (widget.maxY ?? widget.height) /
                            widget.chartTheme.rasterStyle.verticalGaps *
                            i,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: textSizes.first.height / 2,
                left: textSizes.first.width / 2,
              ),
              width: widget.chartTheme.axisBuilder != null &&
                      widget.chartTheme.axisBuilder!.yAxisBuilder != null
                  ? widget.width - kAxis
                  : widget.width,
              height: widget.chartTheme.axisBuilder != null &&
                      widget.chartTheme.axisBuilder!.xAxisBuilder != null
                  ? widget.height - (kAxis - textSizes.first.height / 2)
                  : widget.height,
              child: MouseRegion(
                onHover: onHover,
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
                widget.chartTheme.axisBuilder!.xAxisBuilder != null)
              Container(
                margin: EdgeInsets.only(
                  top: 10 - textSizes.first.height / 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i <= widget.chartTheme.rasterStyle.horizontalGaps;
                        i++)
                      Padding(
                        padding: EdgeInsets.only(
                          right: i ==
                                  widget.chartTheme.rasterStyle.horizontalGaps
                              ? 0
                              : horizontalGap -
                                  (textSizes[((widget.maxX ?? widget.width) /
                                                          widget
                                                              .chartTheme
                                                              .rasterStyle
                                                              .horizontalGaps *
                                                          i)
                                                      .floor()
                                                      .toString()
                                                      .length -
                                                  1]
                                              .width /
                                          2 +
                                      textSizes[((widget.maxX ??
                                                              widget.width) /
                                                          widget
                                                              .chartTheme
                                                              .rasterStyle
                                                              .horizontalGaps *
                                                          (i + 1))
                                                      .floor()
                                                      .toString()
                                                      .length -
                                                  1]
                                              .width /
                                          2),
                        ),
                        child: SizedBox(
                          height: 20,
                          child: widget.chartTheme.axisBuilder!.xAxisBuilder!(
                            context,
                            i,
                            (widget.maxX ?? widget.width) /
                                widget.chartTheme.rasterStyle.horizontalGaps *
                                i,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Size calculateTextSize(String text, TextStyle style) {
    return (TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout())
        .size;
  }

  void onHover(PointerHoverEvent event) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(event.position);
    final double x = localOffset.dx;
    final double y = localOffset.dy;

    ChartPoint? point;

    for (var line in lines) {
      point = line.points.firstWhere(
        (point) {
          final Offset translatedCoordinates =
              point.translatedCoordinatesWithMax(
                  box.size.height,
                  box.size.width,
                  widget.maxX ?? box.size.height,
                  widget.maxY ?? box.size.width);
          var pointX = translatedCoordinates.dx + kAxis;
          var pointY = translatedCoordinates.dy - kAxis;
          var pointSize = line.theme.pointStyle.size ?? 10;
          var pointerRadius = (pointSize / 2);

          return x >= pointX - pointerRadius - widget.labelDetectionZone &&
              x <= pointX + pointerRadius + widget.labelDetectionZone &&
              y >= pointY - pointerRadius - widget.labelDetectionZone &&
              y <= pointY + pointerRadius + widget.labelDetectionZone;
        },
        orElse: () => const ChartPoint(double.infinity, double.infinity),
      );

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
