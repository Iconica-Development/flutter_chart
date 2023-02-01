import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Line line(int offset) {
    return Line(
      points: [
        for (int i = 0; i < 500; i++) ...[
          ChartPoint(
            i.toDouble(),
            50 * sin(i.toDouble() / 10) + offset,
            label:
                '$i: ${(50 * sin(i.toDouble() / 10) + 100).toStringAsFixed(1)}',
          ),
        ],
      ],
      shouldDrawPath: true,
      shouldDrawPoints: true,
      theme: LineTheme(
        labelBoxStyle: const LabelBoxStyle(
          backgroundColor: Color(0xff1D1E22),
          borderColor: Colors.white,
          borderRadius: 5,
          borderWidth: 1,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        highlightedPointStyle: const PointStyle(
          color: Color(0xff92866E),
          size: 10,
          shape: PointShape.circle,
        ),
        lineStyle: const LineStyle(
          color: Color(0xff92866E),
          strokeWidth: 2,
          lineForm: LineForm.curve,
        ),
        pathStyle: PathStyle(
          color: const Color(0xff92866E).withOpacity(0.2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    var labelStyle = const TextStyle(
      color: Colors.white,
      fontSize: 15,
    );
    return Scaffold(
      backgroundColor: const Color(0xff1D1E22),
      appBar: AppBar(
        backgroundColor: const Color(0xff000000),
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 270,
            width: MediaQuery.of(context).size.width - 40,
            child: Padding(
              padding: EdgeInsets.zero,
              child: LineChart(
                key: ValueKey(MediaQuery.of(context).size),
                height: 270,
                width: MediaQuery.of(context).size.width - 80,
                chartTheme: ChartTheme(
                  axisTextStyle: labelStyle,
                  yAxisWidth: 60,
                  xAxisHeight: 20,
                  axisBuilder: AxisBuilder(
                    xAxisBuilder: (context, index, value) {
                      return Text(
                        value.toStringAsFixed(0),
                        style: labelStyle,
                      );
                    },
                    yAxisBuilder: (context, index, value) {
                      return Text(
                        value.toStringAsFixed(0),
                        textAlign: TextAlign.end,
                        style: labelStyle,
                      );
                    },
                  ),
                  rasterStyle: RasterStyle(
                    horizontalGaps: 50,
                    verticalGaps: 5,
                    color: Colors.grey.withOpacity(0.3),
                    rasterType: RasterType.horizontalAndVertical,
                  ),
                ),
                lines: [
                  line(100),
                  line(200),
                ],
                shouldDrawRaster: true,
                maxX: 700,
                maxY: 500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
