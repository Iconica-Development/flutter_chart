import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class LineChartPainter extends CustomPainter {
  /// Constructs a `LineChartPainter`.
  ///
  /// [lines]: The list of lines to be drawn on the chart.
  /// [rasterStyle]: The style configuration for the chart's raster.
  /// [maxX]: The maximum value for the X-axis.
  /// [maxY]: The maximum value for the Y-axis.
  /// [shouldDrawRaster]: Whether to draw the chart's raster.
  /// [horizontalGap]: The horizontal gap between raster lines.
  /// [verticalGap]: The vertical gap between raster lines.
  const LineChartPainter({
    required this.lines,
    required this.rasterStyle,
    this.maxX,
    this.maxY,
    required this.shouldDrawRaster,
    required this.horizontalGap,
    required this.verticalGap,
  });

  final List<Line> lines;
  final RasterStyle rasterStyle;
  final double? maxX;
  final double? maxY;
  final bool shouldDrawRaster;
  final double horizontalGap;
  final double verticalGap;

  @override
  void paint(Canvas canvas, Size size) {
    var maxX = this.maxX ?? size.width;
    var maxY = this.maxY ?? size.height;

    var rasterPaint = Paint()
      ..color = rasterStyle.color
      ..strokeWidth = rasterStyle.strokeWidth
      ..style = PaintingStyle.stroke;

    if (shouldDrawRaster) {
      if (rasterStyle.rasterType == RasterType.vertical ||
          rasterStyle.rasterType == RasterType.horizontalAndVertical) {
        for (var i = 0; i <= rasterStyle.horizontalGaps; i++) {
          canvas.drawLine(
            Offset(i * horizontalGap, 0),
            Offset(i * horizontalGap, size.height),
            rasterPaint,
          );
        }
      }

      if (rasterStyle.rasterType == RasterType.horizontal ||
          rasterStyle.rasterType == RasterType.horizontalAndVertical) {
        for (var i = 0; i <= rasterStyle.verticalGaps; i++) {
          canvas.drawLine(
            Offset(0, i * verticalGap),
            Offset(size.width, i * verticalGap),
            rasterPaint,
          );
        }
      }
    }

    for (var line in lines) {
      final pointPaint = Paint()
        ..color = line.theme.pointStyle.color ?? Colors.blue
        ..strokeWidth = line.theme.pointStyle.size ?? 5
        ..strokeCap = line.theme.pointStyle.shape == PointShape.circle
            ? StrokeCap.round
            : StrokeCap.square;

      final linePaint = Paint()
        ..color = line.theme.lineStyle.color
        ..strokeWidth = line.theme.lineStyle.strokeWidth
        ..style = PaintingStyle.stroke;

      final pathPaint = Paint();
      pathPaint.style = PaintingStyle.fill;

      if (line.theme.pathStyle.color != null) {
        pathPaint.color = line.theme.pathStyle.color!;
      } else if (line.theme.pathStyle.gradient != null) {
        pathPaint.shader = line.theme.pathStyle.gradient!.createShader(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
        );
      }

      if (line.shouldDrawPoints) {
        canvas.drawPoints(
          PointMode.points,
          line.points
              .map((e) => e.translatedCoordinatesWithMax(
                  size.height, size.width, maxX, maxY))
              .toList(),
          pointPaint,
        );
      }

      if (line.shouldDrawLine) {
        if (line.theme.lineStyle.lineForm == LineForm.straight) {
          for (var i = 0; i < line.points.length - 1; i++) {
            canvas.drawLine(
              line.points[i].translatedCoordinatesWithMax(
                  size.height, size.width, maxX, maxY),
              line.points[i + 1].translatedCoordinatesWithMax(
                  size.height, size.width, maxX, maxY),
              linePaint,
            );
          }
        } else if (line.theme.lineStyle.lineForm == LineForm.curve) {
          // Draw curve
          final path = Path();
          path.moveTo(
              line.points[0]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              line.points[0]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dy);

          for (var i = 0; i < line.points.length - 1; i++) {
            final double x1 = line.points[i]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx;
            final double y1 = line.points[i]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy;
            final double x2 = line.points[i + 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx;
            final double y2 = line.points[i + 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy;
            final double midX = (x1 + x2) / 2;
            final double midY = (y1 + y2) / 2;

            path.quadraticBezierTo(x1, y1, midX, midY);
          }

          path.quadraticBezierTo(
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy,
          );

          canvas.drawPath(path, linePaint);
        }
      }

      if (line.shouldDrawPath) {
        if (line.theme.lineStyle.lineForm == LineForm.straight) {
          final path = Path();
          path.moveTo(
              line.points.first
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              line.points.first
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dy);
          for (var i = 0; i < line.points.length - 1; i++) {
            path.cubicTo(
              line.points[i]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              line.points[i]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dy,
              line.points[i + 1]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              line.points[i + 1]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dy,
              line.points[i + 1]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              line.points[i + 1]
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dy,
            );
          }
          path.lineTo(
              line.points.last
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              size.height);
          path.lineTo(
              line.points.first
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              size.height);
          path.close();
          canvas.drawPath(
            path,
            pathPaint,
          );
        } else if (line.theme.lineStyle.lineForm == LineForm.curve) {
          final path = Path();
          path.moveTo(
              line.points.first
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              line.points.first
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dy);
          for (var i = 0; i < line.points.length - 1; i++) {
            final double x1 = line.points[i]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx;
            final double y1 = line.points[i]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy;
            final double x2 = line.points[i + 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx;
            final double y2 = line.points[i + 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy;
            final double midX = (x1 + x2) / 2;
            final double midY = (y1 + y2) / 2;

            path.cubicTo(x1, y1, midX, midY, midX, midY);
          }

          path.cubicTo(
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dx,
            line.points[line.points.length - 1]
                .translatedCoordinatesWithMax(
                    size.height, size.width, maxX, maxY)
                .dy,
          );

          path.lineTo(
              line.points.last
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              size.height);
          path.lineTo(
              line.points.first
                  .translatedCoordinatesWithMax(
                      size.height, size.width, maxX, maxY)
                  .dx,
              size.height);
          path.close();
          canvas.drawPath(
            path,
            pathPaint,
          );
        }
      }
    }

    // draw the highlighted point and label
    for (var line in lines.where((e) => e.highlightedPoint != null)) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: line.highlightedPoint!.label,
          style: line.theme.labelBoxStyle.textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final Offset translatedCoordinates = line.highlightedPoint!
          .translatedCoordinatesWithMax(size.height, size.width, maxX, maxY);

      // Draw label box using labelBoxStyle
      final labelBoxPaint = Paint()
        ..color = line.theme.labelBoxStyle.backgroundColor
        ..style = PaintingStyle.fill;

      // Draw box with border
      final labelBoxBorderPaint = Paint()
        ..color = line.theme.labelBoxStyle.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = line.theme.labelBoxStyle.borderWidth;
      var labelPadding = 5.0;
      var position = getLabelPositionAndSize(
          translatedCoordinates, textPainter, size, labelPadding);
      canvas.drawRect(
        Rect.fromLTWH(
          position.$1,
          position.$2,
          textPainter.width + labelPadding * 2,
          textPainter.height + labelPadding * 2,
        ),
        labelBoxPaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            position.$1,
            position.$2,
            textPainter.width + labelPadding * 2,
            textPainter.height + labelPadding * 2,
          ),
          Radius.circular(line.theme.labelBoxStyle.borderRadius),
        ),
        labelBoxBorderPaint,
      );

      textPainter.paint(
        canvas,
        Offset(
          position.$1 + labelPadding,
          position.$2 + labelPadding,
        ),
      );

      if (line.shouldDrawHighlightedPoint && line.highlightedPoint != null) {
        final highlightedPaint = Paint()
          ..color = line.theme.highlightedPointStyle.color ?? Colors.red
          ..strokeWidth = line.theme.highlightedPointStyle.size ?? 5
          ..strokeCap =
              line.theme.highlightedPointStyle.shape == PointShape.circle
                  ? StrokeCap.round
                  : StrokeCap.square;

        final Offset translatedCoordinates = line.highlightedPoint!
            .translatedCoordinatesWithMax(size.height, size.width, maxX, maxY);
        final double pointX = translatedCoordinates.dx;
        final double pointY = translatedCoordinates.dy;

        canvas.drawPoints(
          PointMode.points,
          [Offset(pointX, pointY)],
          highlightedPaint,
        );
      }
    }
  }

  (double left, double top) getLabelPositionAndSize(
    Offset point,
    TextPainter textPainter,
    Size size,
    double labelPadding,
  ) {
    var distanceBetweenPointAndLabel = 20.0;
    var labelSpaceNeeded = (
      textPainter.width / 2,
      textPainter.height + distanceBetweenPointAndLabel
    );
    // if the label is too close to any edge, move it to the other side
    // for dx constrain between distanceBetweenPointAndLabel and size.width - distanceBetweenPointAndLabel
    return (
      min(
        max(
          point.dx - labelSpaceNeeded.$1 - labelPadding,
          distanceBetweenPointAndLabel / 2,
        ),
        size.width - (labelSpaceNeeded.$1 + labelPadding) * 2,
      ),
      point.dy - labelSpaceNeeded.$2 < 0
          ? point.dy + distanceBetweenPointAndLabel
          : point.dy - labelSpaceNeeded.$2,
    );
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => true;
}
