
import 'package:flutter/cupertino.dart';

class AmapParam {
  static const int routeMap = 0;
  static const int addressDescriptionMap = 1;

  List<double> initialCenterPoint;
  double initialZoomLevel;
  bool enableMyLocation;
  bool enableMyMarker;
  int mapType;

  List<AddressInfo> startAddressList;
  List<AddressInfo> endAddressList;

  AmapParam({
    @required this.initialCenterPoint,
    this.initialZoomLevel = 14,
    this.enableMyLocation = false,
    this.enableMyMarker = false,
    this.startAddressList = const [],
    this.endAddressList = const [],
    this.mapType = routeMap
  });

  toJson() => <String, dynamic> {
    "initialCenterPoint": initialCenterPoint,
    "initialZoomLevel": initialZoomLevel,
    "enableMyLocation": enableMyLocation,
    "enableMyMarker": enableMyMarker,
    "mapType": mapType,
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