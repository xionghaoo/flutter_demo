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
  bool isDisable = true;

  _loadWeatherData() {
    _weatherData = repo.fetchCurrentWeatherByCityName(context, 'changsha');
  }

  _reloadWeatherData() {
    // 重新给future赋值
    _loadWeatherData();
    // 使用新的future重建FutureBuilder
    setState(() {});
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
                child: Text("加载天气数据"),
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
//                    print(snapshot.connectionState);
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
            )
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