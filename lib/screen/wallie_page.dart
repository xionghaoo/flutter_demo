import 'package:flutter/material.dart';

class WalliePage extends StatefulWidget {

  @override
  _WalliePageState createState() => _WalliePageState();
}

class _WalliePageState extends State<WalliePage> {

  @override
  Widget build(BuildContext context) {

    final String username = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
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
                            color: Colors.grey,
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
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
                              Text("充会员获取强大能量", style: TextStyle(color: Colors.white),),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}