import 'package:flutter/material.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://test-api-jlbn.onrender.com/lab2026/v1';
  static const String feedPath = '/feed';
  static const String feedDetailsPath = '/feed/details';
  static const Duration timeout = Duration(seconds: 30);
}

class AppColors {
  AppColors._();

  static const Color teal = Color(0xFF508A7B);
  static const Color scaffoldBackground = Color(0xFFF9F9F9);
}
