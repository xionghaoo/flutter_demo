import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WallieBillPage extends StatefulWidget {
  @override
  _WallieBillPageState createState() => _WallieBillPageState();
}

class _WallieBillPageState extends State<WallieBillPage> {

  Widget _toolbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 10,),
          GestureDetector(
            child: Container(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(Icons.arrow_back, color: Colors.green[500],),
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(width: 10,),
          Text("Bill", style: TextStyle(color: Colors.green[500], fontSize: 20, fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _toolbar(),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("${index + 1} Jan 2020", style: TextStyle(color: Colors.green[500], fontWeight: FontWeight.w500, fontSize: 15),),
                          Expanded(child: SizedBox(),),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(204, 204, 204, 0.2),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Icon(Icons.add_shopping_cart),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Netfix", style: TextStyle(color: Colors.grey[500], fontSize: 12),),
                              Text("\$10.00", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(width: 30,),
                          Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Icon(Icons.chevron_right, color: Colors.grey[400],),
                            ),
                          )
                        ],
                      ),
                      Divider(color: Color.fromRGBO(200, 200, 200, 0.5), endIndent: 10, thickness: 0.3,)
                    ],
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}