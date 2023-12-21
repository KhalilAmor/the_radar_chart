import 'package:flutter/material.dart';

class TickData {
  final int value;
  final bool showLabel;
  final bool showLine;

  TickData({required this.value, this.showLabel = false, this.showLine = true});
}

enum RadarChartShape { circular, polygon }

class RadarDataSet {
  List<num> dataEntries;
  Color fillColor;
  Color borderColor;
  double borderWidth;
  double entryRadius;

  RadarDataSet({
    List<num>? dataEntries,
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    double? entryRadius,
  })  : assert(
          dataEntries == null || dataEntries.isEmpty || dataEntries.length >= 3,
          'Radar needs at least 3 RadarEntry',
        ),
        dataEntries = dataEntries ?? const [],
        fillColor = fillColor ??
            borderColor?.withOpacity(0.2) ??
            Colors.cyan.withOpacity(0.2),
        borderColor = borderColor ?? Colors.cyan,
        borderWidth = borderWidth ?? 2.0,
        entryRadius = entryRadius ?? 5.0;
}

class RadarChartTitle {
  const RadarChartTitle({
    required this.text,
    this.angle = 0,
    this.positionPercentageOffset,
  });

  /// [text] is used to draw titles outside the [RadarChart]
  final String text;

  /// [angle] is used to rotate the title
  final double angle;

  /// [positionPercentageOffset] is the place of showing title on the [RadarChart]
  /// The higher the value of this field, the more titles move away from the chart.
  /// The value of [positionPercentageOffset] takes precedence over the value of
  /// [RadarChartData.titlePositionPercentageOffset], even if it is set.
  final double? positionPercentageOffset;
}

class RadarChartController {
  late bool Function(bool) _rotateToFeature;

  bool Function(bool) get rotateToFeature => _rotateToFeature;
  int _currentStep = 0;
  int get currentStep => _currentStep;
  void initialize(bool Function(bool) rotateCallback) {
    _rotateToFeature = rotateCallback;
  }

  void updateCurrentStep(int step) {
    _currentStep = step;
  }
}
