// import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

import 'package:the_radar_chart/src/models.dart';

class RadarChart extends StatefulWidget {
  final List<TickData> ticks;
  final List<String> features;
  final List<RadarDataSet> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final RadarChartShape shape;
  final RadarChartTitle Function(int, double) getTitle;

  const RadarChart({
    Key? key,
    required this.ticks,
    required this.features,
    required this.data,
    this.reverseAxis = false,
    this.ticksTextStyle = const TextStyle(color: Colors.grey, fontSize: 12),
    this.featuresTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    this.outlineColor = Colors.black,
    this.axisColor = Colors.grey,
    required this.getTitle,
    this.shape = RadarChartShape.polygon,
  }) : super(key: key);

  factory RadarChart.light({
    required List<TickData> ticks,
    required List<String> features,
    required List<RadarDataSet> data,
    required RadarChartTitle Function(int, double) getTitle,
    required RadarChartShape shape,
  }) {
    return RadarChart(
      ticks: ticks,
      features: features,
      data: data,
      reverseAxis: false,
      getTitle: getTitle,
    );
  }

  factory RadarChart.dark({
    required List<TickData> ticks,
    required List<String> features,
    required List<RadarDataSet> data,
    required RadarChartTitle Function(int, double) getTitle,
    required RadarChartShape shape,
  }) {
    return RadarChart(
      ticks: ticks,
      features: features,
      data: data,
      featuresTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      outlineColor: Colors.white,
      axisColor: Colors.grey,
      reverseAxis: false,
      getTitle: getTitle,
      shape: shape,
    );
  }

  @override
  RadarChartState createState() => RadarChartState();
}

class RadarChartState extends State<RadarChart>
    with SingleTickerProviderStateMixin {
  double fraction = 0;
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    ))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });

    animationController.forward();
  }

  @override
  void didUpdateWidget(RadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: RadarChartPainter(
          widget.ticks,
          widget.features,
          widget.data,
          widget.reverseAxis,
          widget.ticksTextStyle,
          widget.featuresTextStyle,
          widget.outlineColor,
          widget.axisColor,
          widget.shape == RadarChartShape.polygon ? widget.features.length : 0,
          fraction,
          getTitle: widget.getTitle),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class RadarChartPainter extends CustomPainter {
  final List<TickData> ticks;
  final List<String> features;
  final List<RadarDataSet> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final int sides;
  final double fraction;
  final double titlePadding;
  final EdgeInsets tickPadding;
  final RadarChartTitle Function(int, double) getTitle;
  RadarChartPainter(
    this.ticks,
    this.features,
    this.data,
    this.reverseAxis,
    this.ticksTextStyle,
    this.featuresTextStyle,
    this.outlineColor,
    this.axisColor,
    this.sides,
    this.fraction, {
    required this.getTitle,
    this.tickPadding = const EdgeInsets.all(4),
    this.titlePadding = 50,
  });

  Path variablePath(Size size, double radius, int sides) {
    var path = Path();
    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    if (sides < 3) {
      // Draw a circle
      path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ));
    } else {
      // Draw a polygon
      Offset startPoint = Offset(radius * cos(-pi / 2), radius * sin(-pi / 2));

      path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

      for (int i = 1; i <= sides; i++) {
        double x = radius * cos(angle * i - pi / 2) + center.dx;
        double y = radius * sin(angle * i - pi / 2) + center.dy;
        path.lineTo(x, y);
      }
      path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    final radius = math.min(centerX, centerY) * 0.65;
    final featureRadius = radius + titlePadding;

    final scale = radius / ticks.last.value;

    // Painting the chart outline
    var outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    var ticksPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    canvas.drawPath(variablePath(size, radius, sides), outlinePaint);
    // Painting the circles and labels for the given ticks (could be auto-generated)
    // The last tick is ignored, since it overlaps with the feature label
    var tickDistance = radius / (ticks.length - 1);
    var tickLabels = reverseAxis ? ticks.reversed.toList() : ticks;

    if (reverseAxis) {
      TextPainter(
        text: TextSpan(text: tickLabels[0].toString(), style: ticksTextStyle),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(canvas, Offset(centerX, centerY - ticksTextStyle.fontSize!));
    }
    for (var tick in ticks) {
      var tickRadius = tickDistance * ticks.indexOf(tick);

      // Check if the line should be drawn
      if (tick.showLine) {
        canvas.drawPath(variablePath(size, tickRadius, sides), ticksPaint);
      }

      // // Check if the label should be drawn
      // if (tick.showLabel) {
      //   TextPainter(
      //     text: TextSpan(text: tick.value.toString(), style: ticksTextStyle),
      //     textDirection: TextDirection.ltr,
      //   )
      //     ..layout(minWidth: 0, maxWidth: size.width)
      //     ..paint(
      //         canvas,
      //         Offset(
      //             centerX + tickPadding.left,
      //             centerY -
      //                 tickRadius -
      //                 ticksTextStyle.fontSize! -
      //                 tickPadding.bottom));
      // }
    }

    // tickLabels
    //     .sublist(
    //         reverseAxis ? 1 : 0, reverseAxis ? ticks.length : ticks.length - 1)
    //     .asMap()
    //     .forEach((index, tick) {
    //   var tickRadius = tickDistance * (index + 1);

    //   canvas.drawPath(variablePath(size, tickRadius, sides), ticksPaint);
    //   TextPainter(
    //     text: TextSpan(text: tick.toString(), style: ticksTextStyle),
    //     textDirection: TextDirection.ltr,
    //   )
    //     ..layout(minWidth: 0, maxWidth: size.width)
    //     ..paint(canvas,
    //         Offset(centerX, centerY - tickRadius - ticksTextStyle.fontSize!));
    // });

    // Painting the axis for each given feature
    var angle = (2 * pi) / features.length;

    features.asMap().forEach((index, feature) {
      var xAngle = cos(angle * index - pi / 2);
      var yAngle = sin(angle * index - pi / 2);
      // var featurePadding = 20.0;
      var featureOffset =
          Offset(centerX + radius * xAngle, centerY + radius * yAngle);

      var textOffset = Offset(
          centerX + featureRadius * xAngle, centerY + featureRadius * yAngle);
      // var textSize = getTextSize(feature, featuresTextStyle.fontSize!,
      //     maxWidth: 100, maxLines: 3);
      canvas.drawLine(centerOffset, featureOffset, ticksPaint);
      // var textOffset = offsetOnSameLine(centerOffset, featureOffset, 100);
      var textPainter = TextPainter(
          text: TextSpan(text: feature, style: featuresTextStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          // strutStyle:
          //     StrutStyle.fromTextStyle(TextStyle(backgroundColor: Colors.red)),
          // ellipsis: '...',
          maxLines: 3);
      textPainter.layout(
        minWidth: 10,
        maxWidth: size.width * .1,
      );
      Offset centeredTextOffset = Offset(
        textOffset.dx - (textPainter.width / 2),
        textOffset.dy - (textPainter.height / 2),
      );

      final featureAngle = angle * index;
      var titleData = getTitle(index, featureAngle);

      // Adjust the rotation angle based on the feature's position around the circle
      // The label should be rotated in the opposite direction of the featureAngle
      // final featureRotationAngle = -featureAngle;

      // Calculate the pivot point for the rotation
      final pivot = Offset(textOffset.dx, textOffset.dy);

      // Translate and rotate the canvas to draw the text
      canvas.save();
      canvas.translate(pivot.dx, pivot.dy);
      canvas.rotate(titleData.angle);

      // Draw the text such that its center aligns with the pivot point
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

      canvas.restore(); // Always restore the canvas after modification

      // textPainter.paint(canvas, centeredTextOffset);
    });

    // Painting each graph
    data.asMap().forEach((index, graph) {
      var graphPaint = Paint()
        ..color = graph.fillColor
        ..style = PaintingStyle.fill;

      var graphOutlinePaint = Paint()
        ..color = graph.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = graph.borderWidth
        ..isAntiAlias = true;

      // Start the graph on the initial point
      var scaledPoint = scale * graph.dataEntries[0] * fraction;
      var path = Path();

      if (reverseAxis) {
        path.moveTo(centerX, centerY - (radius * fraction - scaledPoint));
      } else {
        path.moveTo(centerX, centerY - scaledPoint);
      }

      graph.dataEntries.asMap().forEach((index, point) {
        if (index == 0) return;

        var xAngle = cos(angle * index - pi / 2);
        var yAngle = sin(angle * index - pi / 2);
        var scaledPoint = scale * point * fraction;

        if (reverseAxis) {
          path.lineTo(centerX + (radius * fraction - scaledPoint) * xAngle,
              centerY + (radius * fraction - scaledPoint) * yAngle);
        } else {
          path.lineTo(
              centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
        }
      });

      path.close();
      canvas.drawPath(path, graphPaint);
      canvas.drawPath(path, graphOutlinePaint);
    });

    for (var tick in ticks) {
      var tickRadius = tickDistance * ticks.indexOf(tick);

      // // Check if the line should be drawn
      // if (tick.showLine) {
      //   canvas.drawPath(variablePath(size, tickRadius, sides), ticksPaint);
      // }

      // Check if the label should be drawn
      if (tick.showLabel) {
        TextPainter(
          text: TextSpan(text: tick.value.toString(), style: ticksTextStyle),
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: size.width)
          ..paint(
              canvas,
              Offset(
                  centerX + tickPadding.left,
                  centerY -
                      tickRadius -
                      ticksTextStyle.fontSize! -
                      tickPadding.bottom));
      }
    }
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
