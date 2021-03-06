import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/platform_view/amap_param.dart';
import 'package:flutter_demo/platform_view/amap_view.dart';

class AmapPage extends StatefulWidget {

  @override
  _AmapPageState createState() => _AmapPageState();
}

class _AmapPageState extends State<AmapPage> {

  static const platform = const MethodChannel("xh.zero/map");

  Future<void> _startNativePage() async {
    await platform.invokeMethod("startAMapPage");
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("高德地图测试"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("开启原生高德地图页面"),
              onPressed: () {
                _startNativePage();
              },
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("下面是高德地图的Flutter widget"),
            ),
            Expanded(
              child: AmapView(AmapParam(
                initialCenterPoint: [22.630019, 114.068159],
                enableMyMarker: true,
                mapType: AmapParam.addressDescriptionMap,
                startAddressList: [
                  // 114.038225,22.618959
                  AddressInfo(GeoPoint(22.618959, 114.038225), "起点"),
                  // 114.109808,22.568798 麦德龙
                  AddressInfo(GeoPoint(22.568798, 114.109808), "起点"),
                ],
                endAddressList: [
                  // 114.060541,22.529242
                  AddressInfo(GeoPoint(22.529242, 114.060541), "终点"),
                  // 114.087063,22.548665 华新
                  AddressInfo(GeoPoint(22.548665, 114.087063), "终点"),
                ]
              )),
            )
          ],
        ),
      ),
    );
  }
}