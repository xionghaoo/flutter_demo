
class AmapParam {
  List<double> initialCenterPoint;

  AmapParam({this.initialCenterPoint});

  toJson() => <String, dynamic> {
    "initialCenterPoint": initialCenterPoint
  };
}