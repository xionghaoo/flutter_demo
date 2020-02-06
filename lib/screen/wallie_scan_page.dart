import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils.dart';

class WallieScanPage extends StatefulWidget {

  @override
  _WallieScanPageState createState() => _WallieScanPageState();
}

class _WallieScanPageState extends State<WallieScanPage> {
  @override
  Widget build(BuildContext context) {
    setStatusBarLight();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.green
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).padding.top,),
              Text("Scan")
            ],
          ),
        ),
      ),
    );
  }
}