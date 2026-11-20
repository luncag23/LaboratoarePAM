import 'package:flutter/material.dart';

/// Transformă un string hex (`#RRGGBB`, `RRGGBB` sau `AARRGGBB`) în [Color].
Color parseHexColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
