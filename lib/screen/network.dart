import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/repo/data/weather_data.dart';
import 'package:flutter_demo/repo/repository.dart';

class NetworkPage extends StatefulWidget {

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {

  Repository repo = Repository();
  Future<WeatherData> _weatherData;
//  bool isLoading = false;
  bool isDisable = false;
  Widget _resultContent;

  _loadWeatherData() {
    _weatherData = repo.fetchCurrentWeatherByCityName(context, 'changsha');
  }

  _reloadWeatherData() {
    // 重新给future赋值
    _loadWeatherData();
    // 使用新的future重建FutureBuilder
    setState(() {});
  }

  // 可以灵活的管理UI的刷新
  _loadDataManual() {
    setState(() {
      isDisable = true;
      _resultContent = CircularProgressIndicator();
    });
    repo.fetchCurrentWeatherByCityName(context, 'shenzhen').then((data) {
      _resultContent = Text("城市：${data.cityName}, 能见度：${data.visibility}");
    }).catchError((e) {
      _resultContent = Text("加载失败");
    }).whenComplete(() {
      setState(() {
        isDisable = false;
      });
    });

  }

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
    print("mounted: $mounted");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("网络")),
      body: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: RaisedButton(
                child: Text("使用FutureBuilder加载数据"),
                textColor: Colors.white,
                color: Colors.amberAccent,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.white,
                onPressed: () {
                  _reloadWeatherData();
                },
              ),
            ),
            Container(
              child: Center(
                child: FutureBuilder<WeatherData>(
                  future: _weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        return Text("城市： ${data.cityName}，可见度：${data.visibility}");
                      }
                      if (snapshot.hasError) {
                        return Text("error: ${snapshot.error}");
                      }

                      return Text("lucky result");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: RaisedButton(
                child: Text("自定义加载数据"),
                textColor: Colors.white,
                color: Colors.amberAccent,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.white,
                onPressed: isDisable ? null : () {_loadDataManual();},
              ),
            ),
            Container(
                child: Center(
                  child: _resultContent
                )
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(NetworkPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }
}