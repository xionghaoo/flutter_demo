import 'package:flutter/material.dart';
import 'package:flutter_demo/core/cascade_selector_widget.dart';
import 'package:flutter_demo/core/common_widgets.dart';
import 'package:flutter_demo/platform_view/text_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddressSelectPage extends StatefulWidget {

  static final path = "/addressSelect";

  @override
  _AddressSelectPageState createState() => _AddressSelectPageState();
}

class _AddressSelectPageState extends State<AddressSelectPage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Animation _animation;

  GlobalKey _sliderKey = GlobalKey();
  List<GlobalKey> _tabKeys = [];

  double _slideLeftMargin = 0;

  List<String> _province = [
    "北京市",
    "广东省",
    "湖南省",
    "贵州省",
    "湖北省"
  ];

  CascadeSelectorWidget _addressSelectorWidget;

  @override
  void initState() {
    super.initState();
//    _controller = AnimationController(
//      duration: const Duration(milliseconds: 500),
//      vsync: this
//    );
//
//    _curvedAnimation = CurvedAnimation(
//      parent: _controller,
//      curve: Curves.ease
//    )..addStatusListener((state) {
//    });
//
//    _animation = Tween<double>(begin: 0, end: 100).animate(_curvedAnimation);
//
//    _tabKeys.add(GlobalKey());
//    _tabKeys.add(GlobalKey());
//    _tabKeys.add(GlobalKey());

//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      RenderBox slider = _sliderKey.currentContext.findRenderObject();
//      Size sliderSize = slider.size;
//      RenderBox tabOne = _tabKeys[0].currentContext.findRenderObject();
//      Size tabOneSize = tabOne.size;
//      final leftMargin = (tabOneSize.width - sliderSize.width) / 2;
//      setState(() {
//        _slideLeftMargin = leftMargin;
//      });
//    });

  }

  @override
  Widget build(BuildContext context) {
//    _addressSelectorWidget = AddressSelectorWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text("地址选择"),
      ),
      body: Center(
        child: Container(
          child: CascadeSelectorWidget(
              List.generate(3, (index) => ["地址1-${index}", "地址2-${index}", "地址3-${index}", "地址4-${index}"]),
              completeCallBack: (address) {
                Fluttertoast.showToast(msg: "地址：${address}");
              })
        ),
      ),
    );
  }
}