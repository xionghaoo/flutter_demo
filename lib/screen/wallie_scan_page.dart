import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils.dart';

class WallieScanPage extends StatefulWidget {
  static final String path = "/wallieScan";
  @override
  _WallieScanPageState createState() => _WallieScanPageState();
}

class _WallieScanPageState extends State<WallieScanPage> {
  @override
  Widget build(BuildContext context) {
    setStatusBarLight();
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.green
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top,),
//                Text("Scan")
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Another Payment Methods", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(166, 93, 202, 0.2),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Center(
                          child: Icon(Icons.phone_android, color: Color.fromRGBO(166, 93, 202, 1),)
                        )
                      ),
                      SizedBox(width: 10,),
                      Text("支付宝"),
                      Expanded(child: SizedBox(),),
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 202, 93, 0.2),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Center(
                              child: Icon(Icons.payment, color: Color.fromRGBO(96, 202, 93, 1),)
                          )
                      ),
                      SizedBox(width: 10,),
                      Text("微信")
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}