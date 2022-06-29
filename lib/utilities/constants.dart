import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// For main page BottomNavigator
const double iconSize = 30;
const double selectedFontSize = 14;
const double unselectedFontSize = 14;

// For Drawing Canvas
const double canvasSize = 300;
const double borderSize = 2;
const double strokeWidth = 16;
const int mnistSize = 28;

final backgroundColor = Colors.grey[200];

extension MyDateTimeExtension on DateTime {
  /// Custom made extension to format Date from ISO string to dd/MM/yy
  String formatDate({String pattern = "hh : MM a"}) {
    return DateFormat(pattern).format(this);
  }
}
