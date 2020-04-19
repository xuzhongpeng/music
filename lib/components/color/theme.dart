import 'package:flutter/material.dart';

class JUTheme {
  factory JUTheme() => _instance;

  static final _instance = JUTheme._singleTon();

  JUTheme._singleTon();

  ThemeData _theme;
  ThemeData get theme => _theme;
  init(context) {
    _theme = Theme.of(context);
  }
}
