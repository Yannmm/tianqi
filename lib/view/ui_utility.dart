import 'package:flutter/material.dart';

/// Screen height - status bar height - navigation bar height
double kGetModalSheetHeight1(BuildContext context) =>
    MediaQuery.of(context).copyWith().size.height -
    View.of(context).padding.top / View.of(context).devicePixelRatio -
    kBottomNavigationBarHeight;

/// Screen height - status bar height
double kGetModalSheetHeight2(BuildContext context) =>
    MediaQuery.of(context).copyWith().size.height -
    View.of(context).padding.top / View.of(context).devicePixelRatio;
