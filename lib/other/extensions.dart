import 'package:flutter/material.dart';

extension ToMaterialColor on Color {
  MaterialColor get asMaterialColor {
    Map<int, Color> shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]
        .asMap()
        .map((key, value) => MapEntry(value, withOpacity(1 - (1 - (key + 1) / 10))));

    return MaterialColor(value, shades);
  }
}

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 0, height: 0);
  }
}

extension StringExtension on String {
  double textHeight(TextStyle style, double textWidth, double padding) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 3,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final countLines = (textPainter.size.width / textWidth).ceil();
    final height = countLines * textPainter.size.height;
    return height + padding;
  }
}

String getNoun(int number, String one, String two, String three) {
  var n = number.abs();
  n %= 100;
  if (n >= 5 && n <= 20) {
    return "$number $three";
  }
  n %= 10;
  if (n == 1) {
    return "$number $one";
  }
  if (n >= 2 && n <= 4) {
    return "$number $two";
  }
  return "$number $three";
}