import 'package:flutter/material.dart';
import 'package:flutter_demo/core/network.dart';
import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/theme/colors.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:redux/redux.dart';

class WallieLoginPage extends StatefulWidget {

  static final String path = "/wallieLogin";

  @override
  _WallieLoginPageState createState() => _WallieLoginPageState();
}

class _WallieLoginPageState extends State<WallieLoginPage> {
  TextEditingController _pwdController;
  FocusNode _pwdFocusNode;
  TextEditingController _accountController;
  FocusNode _accountFocusNode;

  // dart会自动判断返回类型
  _login(BuildContext context, String username, String password) async {
    StoreProvider.of<AppState>(context)
        .dispatch(LoginAction(context, username, password, ApiResponse(Status.none)));
  }

  @override
  void initState() {
    super.initState();
    _pwdController = TextEditingController();
    _pwdController.addListener(() {
//      print("input password: ${_pwdController.text}");
    });
    _pwdFocusNode = FocusNode();
    _pwdFocusNode.addListener(() {
//      print("keyboard height: $_keyboardHeight, focus: ${_pwdFocusNode.hasFocus}");
    });

    _accountController = TextEditingController();
    _accountFocusNode = FocusNode();
    _accountFocusNode.addListener(() {
    });

  }

  @override
  void dispose() {
    _pwdController.dispose();
    _pwdFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WallieLoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _accountController.text = "ningque";
    _pwdController.text = "n123";
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.clip,
              children: <Widget>[
                Positioned(
                  top: 140,
                  left: 0,
                  child: Container(
                    width: 140,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60))
                  ),
                ),
              ],
            ),
            Stack(
              overflow: Overflow.clip,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 200,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(60))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                          child: Text("Login To Your Account", style: TextStyle(color: titleColor, fontSize: 16)),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey,
                                child: Center(
                                    child: Icon(Icons.person_outline, color: Colors.white,)
                                )
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.grey,
                                height: 50,
                                margin: EdgeInsets.only(left: 2),
                                child: TextField(
                                  autofocus: false,
                                  maxLines: 1,
                                  controller: _accountController,
                                  focusNode: _accountFocusNode,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: hintColor),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey,
                                child: Center(
                                    child: Icon(Icons.lock_outline, color: Colors.white)
                                )
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.grey,
                                height: 50,
                                margin: EdgeInsets.only(left: 2),
                                child: TextField(
                                  autofocus: false,
                                  controller: _pwdController,
                                  focusNode: _pwdFocusNode,
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: hintColor),
                                    border: InputBorder.none,
//                                  suffixIcon: Icon(Icons.remove_red_eye),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 50,
                                child: Material(
                                  color: Colors.brown,
                                  child: InkWell(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(width: 15,),
                                        Text("Sign In", style: TextStyle(color: hintColor),),
                                        Expanded(
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.arrow_right, color: hintColor,)
                                          ),
                                        ),
                                        SizedBox(width: 15,)
                                      ],
                                    ),
                                    onTap: () {
                                      // 在键盘隐藏后，布局未完全恢复原状，调用unfocus会无效
                                      _accountFocusNode.unfocus();
                                      _pwdFocusNode.unfocus();
                                      if (_accountController.text.isEmpty || _pwdController.text.isEmpty) {
                                        Fluttertoast.showToast(msg: "账号密码不能为空");
                                        return;
                                      }
                                      _login(context, _accountController.text, _pwdController.text);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: FlatButton(
                                  child: Text("Forget Password?", style: TextStyle(color: hintColor), textAlign: TextAlign.center,),
                                  onPressed: () {
                                    Fluttertoast.showToast(msg: "忘记密码");
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}