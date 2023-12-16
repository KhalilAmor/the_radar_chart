import 'package:flutter/rendering.dart';

Size getTextSize(String text, double fontSize,
    {double? maxWidth, int maxLines = 1}) {
  final constraints = BoxConstraints(
      maxWidth: maxWidth ?? 400.0,
      minHeight: 0.0,
      minWidth: 0.0,
      maxHeight: fontSize * maxLines);

  RenderParagraph renderParagraph = RenderParagraph(
    TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
    maxLines: maxLines,
  );
  renderParagraph.layout(constraints);
  double width = renderParagraph.getMinIntrinsicWidth(fontSize).ceilToDouble();
  double height =
      renderParagraph.getMinIntrinsicHeight(fontSize).ceilToDouble();
  return Size(width, height);
}

Offset offsetOnSameLine(Offset p1, Offset p2, double x3) {
  double slope = (p2.dy - p1.dy) / (p2.dx - p1.dx);
  double y3 = p1.dy + slope * (x3 - p1.dx);
  return Offset(x3, y3);
}
