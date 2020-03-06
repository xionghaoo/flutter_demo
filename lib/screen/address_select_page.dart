import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/cascade_selector_widget.dart';
import 'package:flutter_demo/core/common_widgets.dart';
import 'package:flutter_demo/platform_view/text_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart' show rootBundle;

class AddressSelectPage extends StatefulWidget {

  static final path = "/addressSelect";

  @override
  _AddressSelectPageState createState() => _AddressSelectPageState();
}

class _AddressSelectPageState extends State<AddressSelectPage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Animation _animation;

  GlobalKey _sliderKey = GlobalKey();
  List<GlobalKey> _tabKeys = [];

  double _slideLeftMargin = 0;
  List<String> _provinceNames = [];
  Map<String, int> _provinceMap = Map();
  List<String> _cityNames = [];

  int _currentProvince;
  Map<String, String> _currentCityMap = Map();
  List<List<String>> _data = [];
  Map<String, Province> _provinces;
  String currentSelectedProvince;
  String currentSelectedCity;
  CascadeSelectorController _cascadeSelectorController = CascadeSelectorController();

  Future<Map<String, Province>> loadData() async {
    String str = await rootBundle.loadString('assets/china_area.json');
    List<dynamic> citiesJson = json.decode(str);
    print("cities: ${citiesJson.length}");

    Map<String, Province> provinces = Map();
    for (int i = 0; i < citiesJson.length; i++) {
      Map<String, dynamic> province = citiesJson[i];
      List<dynamic> cities = province['cities'];
      String provinceName = province['province_name'];
      if (provinceName != null) {
        Map<String, City> cityMap = Map();
        for (int j = 0; j < cities.length; j++) {
          List<dynamic> districts = cities[j]['districts'];
          String cityName = cities[j]['city_name'];
          String cityCode = cities[j]['city_code'];
          Map<String, District> districtMap = Map();
          for (int k = 0; k < districts.length; k++) {
            Map<String, dynamic> district = districts[k];
            final String districtName = district['district_name'];
            final String districtCode = district['district_code'];
            if (districtName != null) {
              districtMap.putIfAbsent(districtName, () => District(districtName, districtCode));
            }
          }
          if (cityName != null) {
            cityMap.putIfAbsent(cityName, () => City(cityName, cityCode, districtMap));
          }
        }
        provinces.putIfAbsent(provinceName, () => Province(provinceName, cityMap));
      }
    }
    return provinces;
  }

  Future<List<_Province>> loadProvince() async {
    String str = await rootBundle.loadString('assets/china_area/province_list.json');
    Map<String, dynamic> data = json.decode(str);
    List<dynamic> provinces = data['provinces'];
    List<_Province> result = [];
    for (int i = 0; i < provinces.length; i++) {
      Map<String, dynamic> province = provinces[i];
      _provinceMap.putIfAbsent(province['name'], () => province['code']);
      result.add(_Province(province['name'], province['code']));
    }
    return result;
  }

  Future<List<String>> loadCities(int provinceCode) async {
    await Future.delayed(Duration(seconds: 1));

    String str = await rootBundle.loadString('assets/china_area/${provinceCode}/city_list.json');
    Map<String, dynamic> data = json.decode(str);
    List<dynamic> provinces = data['cities'];
    List<String> result = [];
    for (int i = 0; i < provinces.length; i++) {
      Map<String, dynamic> province = provinces[i];
      _currentCityMap.putIfAbsent(province['city_name'], () => province['city_code']);
      result.add(province['city_name']);
    }
    return result;
  }

  Future<List<String>> loadDistricts(int provinceCode, String cityCode) async {
    String str = await rootBundle.loadString('assets/china_area/${provinceCode}/${cityCode}/district_list.json');
    Map<String, dynamic> data = json.decode(str);
    List<dynamic> provinces = data['districts'];
    List<String> result = [];
    for (int i = 0; i < provinces.length; i++) {
      Map<String, dynamic> province = provinces[i];
      result.add(province['district_name']);
    }
    return result;
  }

//  Widget _networkSelectorWidget() {
//    return Container(
//        child: CascadeSelectorWidget(_data,
//          completeCallBack: (address) {
//          },
//          maxTabsNum: 3,
//          onAddTab: (itemName, index, complete) {
//            if (index == 0) {
//              print("选择：${itemName} ${_provinceMap[itemName]}, ${_data.length}");
//
//              _currentProvince = _provinceMap[itemName];
//              loadCities(_currentProvince).then((value) {
//                setState(() {
//                  if (index == _data.length - 1) {
//                    _data.add(value);
//                  } else {
//                    _data[index + 1] = value;
//                  }
//                });
//                complete();
//              });
//            } else if (index == 1) {
//              print("选择：${itemName} ${_currentCityMap[itemName]}, ${_data.length}");
//
//              loadDistricts(_currentProvince, _currentCityMap[itemName]).then((value) {
//                setState(() {
//                  if (index == _data.length - 1) {
//                    _data.add(value);
//                  } else {
//                    _data[index + 1] = value;
//                  }
//                });
//                complete();
//              });
//            } else {
//              complete();
//            }
//          },
//        )
//    );
//  }

  @override
  void initState() {
    super.initState();
//    loadProvince().then((value) {
//      for (int i = 0; i < value.length; i++) {
//        _provinceNames.add(value[i].name);
//      }
//      setState(() {
//        _data.add(_provinceNames);
//      });
//    }).catchError((e) => print(e));

    loadData().then((value) {
      _provinces = value;
      setState(() {
        _data.add(_provinces.keys.toList());
//        _cascadeSelectorController.pagesData = [_provinces.keys.toList()];
      });
      print("provinces: ${_provinces.length}");
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("地址选择"),
      ),
      body: Center(
        child: Container(
          child: Container(
              child: CascadeSelectorWidget(_data,
                selectorController: _cascadeSelectorController,
                completeCallBack: (address) {
                  Fluttertoast.showToast(msg: "selected: ${address}");
                },
                maxTabsNum: 3,
                onAddTab: (currentPage, complete) {
                  final selectedPages = _cascadeSelectorController.selectedPages;
                  if (currentPage == 0) {
                    complete(_provinces[selectedPages[0]].cityMap.keys.toList());
                  } else if (currentPage == 1) {
                    complete(_provinces[selectedPages[0]].cityMap[selectedPages[1]].districtMap.keys.toList());
                  } else {
                    complete(null);
                  }
                  print("selected pages: ${_cascadeSelectorController.selectedPages}, current page: ${currentPage}, total: ${_data.length}");
                },
              )
          )
        )
      )
    );
  }
}

class _Province {
  final String name;
  final int code;
  _Province(this.name, this.code);
}

class Province {
  final String name;
  final Map<String, City> cityMap;
  Province(this.name, this.cityMap);
}

class City {
  final String name;
  final String code;
  final Map<String, District> districtMap;
  City(this.name, this.code, this.districtMap);
}

class District {
  final String name;
  final String code;
  District(this.name, this.code);
}