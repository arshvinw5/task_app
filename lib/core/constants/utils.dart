import 'package:flutter/widgets.dart';

Color strenthColor(Color color, double factor) {
  int r = (color.red * factor).clamp(0, 255).toInt();
  int g = (color.green * factor).clamp(0, 255).toInt();
  int b = (color.blue * factor).clamp(0, 255).toInt();

  return Color.fromARGB(color.alpha, r, g, b);
}

List<DateTime> generateWeekDates(int weekOffSet) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffSet * 7));

  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

//rgb -> hex
String rgbToHex(Color color) {
  return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

//hex-> rgb
Color hexToColor(String hex) {
  hex = hex.replaceAll('#', ''); // remove leading #
  if (hex.length == 6) {
    hex = 'FF$hex'; // add opacity if not provided
  }
  return Color(int.parse(hex, radix: 16));
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
