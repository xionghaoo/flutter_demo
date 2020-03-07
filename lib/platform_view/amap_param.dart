
import 'package:flutter/cupertino.dart';

class AmapParam {
  List<double> initialCenterPoint;
  double initialZoomLevel;

  AmapParam({
    @required this.initialCenterPoint,
    this.initialZoomLevel = 14
  });

  toJson() => <String, dynamic> {
    "initialCenterPoint": initialCenterPoint,
    "initialZoomLevel": initialZoomLevel
  };
}