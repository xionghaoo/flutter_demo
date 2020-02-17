import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/core/common_widgets.dart';
import 'package:flutter_demo/core/utils.dart' as utils;
import 'package:flutter_demo/screen/wallie_login_page.dart';

class WallieProfilePage extends StatefulWidget {

  static final String path = "/wallieProfile";

  final String username;

  WallieProfilePage({this.username});

  @override
  _WallieProfilePageState createState() => _WallieProfilePageState();
}

class _WallieProfilePageState extends State<WallieProfilePage> {

  Widget _profileItemWidget(String title, String content, IconData icon) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10,),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(200, 200, 200, 0.2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(child: Icon(icon, color: Colors.green,)),
              ),
              SizedBox(width: 10,),
              Text(title, style: TextStyle(color: Colors.black54)),
              Expanded(child: SizedBox(),),
              Text(content, style: TextStyle(color: Colors.black54),),
              SizedBox(width: 5,),
              Icon(Icons.chevron_right, color: Colors.grey[500],),
              SizedBox(width: 10,)
            ],
          ),
        ),
      ),
      onTap: () {
        print("clicked");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    utils.setStatusBarDark();
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network("http://pic.17qq.com/uploads/uttwrwuwcx.jpeg", width: 50, height: 50, fit: BoxFit.cover,)
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.username, style: TextStyle(color: Colors.white30, fontSize: 16),),
                          Text("16700001111", style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                _profileItemWidget("Balance", "\$115.0", Icons.account_balance_wallet),
                _profileItemWidget("QR Code", "", Icons.code),
                _profileItemWidget("Barcode", "", Icons.code),
                _profileItemWidget("Password", "1442***", Icons.lock),
                _profileItemWidget("Fingerprint", "", Icons.fingerprint),
                _profileItemWidget("Email", "671314212@qq.com", Icons.email),
                SizedBox(height: 20,),
                // 退出按钮,
                InkBox(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromRGBO(41, 230, 60, 0.1),
                  child: Container(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Center(
                            child: Icon(Icons.exit_to_app, color: Colors.white,),
                          ),
                        ),
                        Expanded(child: SizedBox(),),
                        Text("Sign Out", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => AlertDialog(
                          title: Text("退出App?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("确定"),
                              onPressed: () {

                                Navigator.of(context).pushNamedAndRemoveUntil(WallieLoginPage.path, (route) => false);
                              },
                            )
                          ],
                        )
                    );
                  },
                ),
                SizedBox(height: 60,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}