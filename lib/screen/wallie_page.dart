import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalliePage extends StatefulWidget {

  @override
  _WalliePageState createState() => _WalliePageState();
}

class _WalliePageState extends State<WalliePage> {

  Widget _toolbar(String username) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Hello!", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
              Text(username)
            ],
          ),
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(230, 230, 230, 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Center(
                  child: Icon(Icons.notifications),
                ),
              ),
              Positioned(
                left: 35,
                top: -5,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _menuItemWidget(String menuTitle, IconData icon, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                  child: Icon(icon)
              ),
            ),
            SizedBox(height: 10),
            Text(
              menuTitle,
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _specialPromoCard(String title, String content) {
    const double radius = 10.0;
    return Container(
      height: 240,
      decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 15, )
          ]
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 80,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radius), bottomRight: Radius.circular(radius))
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    SizedBox(height: 5,),
                    Text(content, style: TextStyle(color: Colors.grey, fontSize: 13),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _tabItemWidget(IconData icon) {
    final diameter = MediaQuery.of(context).size.width / 3 - 5;
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(diameter / 2),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(diameter / 2),
        ),
        child: InkWell(
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon),
            ),
          ),
          onTap: () {
            Fluttertoast.showToast(msg: "click tab item");
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    // 获取传递到本页面的参数
    final String username = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _toolbar(username),
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox.expand(),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("GoPremium", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                            Text("成为人民币玩家", style: TextStyle(color: Colors.white),),
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text("Features", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Wrap(
                                spacing: 20,
                                alignment: WrapAlignment.spaceBetween,
                                children: <Widget>[
                                  // row one
                                  _menuItemWidget("Top up", Icons.access_time, Color.fromRGBO(88, 114, 226, 0.2)),
                                  _menuItemWidget("Transfer", Icons.near_me, Color.fromRGBO(231, 239, 56, 0.2)),
                                  _menuItemWidget("Internet", Icons.network_check, Color.fromRGBO(68, 239, 56, 0.2)),
                                  _menuItemWidget("Wallet", Icons.content_paste, Color.fromRGBO(239, 56, 96, 0.2)),
                                  // row two
                                  _menuItemWidget("Bill", Icons.content_paste, Color.fromRGBO(231, 239, 56, 0.2)),
                                  _menuItemWidget("Games", Icons.games, Color.fromRGBO(68, 239, 56, 0.2)),
                                  _menuItemWidget("Mobile Prepaid", Icons.phone_android, Color.fromRGBO(239, 56, 96, 0.2)),
                                  _menuItemWidget("More", Icons.more_horiz, Color.fromRGBO(88, 114, 226, 0.2)),
                                ],
                              )
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Speical Promo",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        "View all",
                                        style: TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                      onTap: () {
                                        Fluttertoast.showToast(msg: "View All");
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: _specialPromoCard("Bonus Crashback", "A card is a sheet of Material used to represent some related information, for example an album, a geographical location, a meal, contact details, etc."),
                                    ),
                                    SizedBox(width: 20,),
                                    Flexible(
                                        flex: 1,
                                        child: _specialPromoCard("Daily Diskon", "BoxShadow can cast non-rectangular shadows if the box is non-rectangular (e.g., has a border radius or a circular shape).")
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 10)
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _tabItemWidget(Icons.home),
                        _tabItemWidget(Icons.style),
                        _tabItemWidget(Icons.person)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}