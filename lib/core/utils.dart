import 'package:flutter/services.dart';

void setStatusBarDark() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

void setStatusBarLight() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}