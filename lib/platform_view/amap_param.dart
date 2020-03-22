
import 'package:flutter/cupertino.dart';

class AmapParam {
  List<double> initialCenterPoint;
  double initialZoomLevel;
  bool enableMyLocation;
  bool enableMyMarker;

  List<AddressInfo> startAddressList;
  List<AddressInfo> endAddressList;

  AmapParam({
    @required this.initialCenterPoint,
    this.initialZoomLevel = 14,
    this.enableMyLocation = false,
    this.enableMyMarker = false,
    this.startAddressList = const [],
    this.endAddressList = const []
  });

  toJson() => <String, dynamic> {
    "initialCenterPoint": initialCenterPoint,
    "initialZoomLevel": initialZoomLevel,
    "enableMyLocation": enableMyLocation,
    "enableMyMarker": enableMyMarker,
    "startAddressList": startAddressList,
    "endAddressList": endAddressList
  };
}

class AddressInfo {
  GeoPoint geo;
  String address;
  AddressInfo(this.geo, this.address);

  toJson() => <String, dynamic> {
    "geo": geo,
    "address": address
  };
}

class GeoPoint {
  double lat;
  double lng;
  GeoPoint(this.lat, this.lng);

  toJson() => <String, dynamic> {
    "lat": lat,
    "lng": lng
  };
}