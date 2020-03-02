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

  @override
  void initState() {
    super.initState();
    loadProvince().then((value) {
      for (int i = 0; i < value.length; i++) {
        _provinceNames.add(value[i].name);
      }
      setState(() {
        _data.add(_provinceNames);
      });
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
          child: CascadeSelectorWidget(_data,
            completeCallBack: (address) {
//              Fluttertoast.showToast(msg: "地址：${address}");
            },
            maxTabsNum: 3,
            onAddTab: (itemName, index) {
              if (_data.length == 1) {
                print("选择：${itemName} ${_provinceMap[itemName]}, ${_data.length}");

                _currentProvince = _provinceMap[itemName];
                loadCities(_currentProvince).then((value) {
                  setState(() {
                    if (index == _data.length - 1) {
                      _data.add(value);
                    } else {
                      _data[index + 1] = value;
                    }
                  });
                });
              } else if (_data.length == 2) {
                print("选择：${itemName} ${_currentCityMap[itemName]}, ${_data.length}");

                loadDistricts(_currentProvince, _currentCityMap[itemName]).then((value) {
                  setState(() {
                    if (index == _data.length - 1) {
                      _data.add(value);
                    } else {
                      _data[index + 1] = value;
                    }
                  });
                });
              }
            },
          )
        ),
      ),
    );
  }
}

class _Province {
  final String name;
  final int code;
  _Province(this.name, this.code);
}