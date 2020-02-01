import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeCallPage extends StatefulWidget {

  @override
  _NativeCallPageState createState() => _NativeCallPageState();
}

class _NativeCallPageState extends State<NativeCallPage> {

  static const CHANNEL = 'xh.zero/battery';

  static const platform = const MethodChannel(CHANNEL);
  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    } on MissingPluginException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("原生调用"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(_batteryLevel, style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            RaisedButton(
              child: Text("查询电池电量"),
              onPressed: _getBatteryLevel
            )
          ],
        ),
      ),
    );
  }
}