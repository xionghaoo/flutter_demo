import 'package:flutter/material.dart';

import 'common_widgets.dart';

class AddressSelectorWidget extends StatefulWidget {

//  final List<String> provinces;
//  final List<String> cities;
//  final List<String> areas;
//
//  AddressSelectorWidget({
//    @required this.provinces,
//    @required this.cities,
//    @required this.areas
//  }): assert(provinces != null), assert(cities != null), assert(areas != null);

  @override
  _AddressSelectorWidgetState createState() => _AddressSelectorWidgetState();
}

class _AddressSelectorWidgetState extends State<AddressSelectorWidget> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Animation _animation;

  GlobalKey _sliderKey = GlobalKey();
  List<GlobalKey> _tabKeys = [];

  PageController _pageController = PageController(initialPage: 0);

  List<String> _addresses = ["请选择"];

  Animation _selectorTranslateXAnim;
  Animation _defaultSelectorTranslateXAnim;

  void addAddress(String address) {
    setState(() {
      _addresses.add(address);
    });
  }

  double _slideLeftMargin = 0;
  double _selectorOpacity = 1;

  int _previousPage = 0;

  bool _isAddTab = false;

  Widget _tabWidget(Function(int) onTap, Key key, String content, int index) {
    return InkBox(
      onTap: () {onTap(index);},
      child: Container(
        key: key,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(content),
        ),
      ),
    );
  }

  List<Widget> _tabWidgets() {
    List<Widget> tabs = [];
    for (int i = 0; i < _tabKeys.length; i++) {
      final onTap = (index) {
//        RenderBox slider = _sliderKey.currentContext.findRenderObject();
//        Offset offset = slider.localToGlobal(Offset.zero);
//        RenderBox currentTab = _tabKeys[i].currentContext.findRenderObject();
//        double extraWidth = (currentTab.size.width - slider.size.width) / 2;
//        double totalWidth = 0;
//        for (int j = 0; j <= i; j++) {
//          RenderBox tab = _tabKeys[j].currentContext.findRenderObject();
//          totalWidth += tab.size.width;
//        }
//        final sliderAnimEndDx = totalWidth - extraWidth - slider.size.width - _slideLeftMargin;
//
//        _animation = Tween<double>(begin: offset.dx - _slideLeftMargin, end: sliderAnimEndDx).animate(_curvedAnimation);
//        _selectorTranslateXAnim = Tween<double>(begin: 0, end: 0).animate(_curvedAnimation);
//        _controller.value = 0;
//        _controller.forward();
        if (_previousPage != index) {
          moveSlider(_tabKeys[i], i);
        }

        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);

      };
      Widget widget = _tabWidget(onTap, _tabKeys[i], _addresses[i], i);

      if (i == _tabKeys.length - 1 && _tabKeys.length >= 2) {
        widget = AnimatedBuilder(
          animation: _selectorTranslateXAnim,
          builder: (context, child) => Transform.translate(
            offset: Offset(_selectorTranslateXAnim.value, 0),
            child: Opacity(
              opacity: _selectorOpacity,
              child: _tabWidget(onTap, _tabKeys[i], _addresses[i], i)
            ),
          ),
        );
      }
      tabs.add(Flexible(
        flex: 1,
        child: widget,
      ));
    }
    return tabs;
  }

  Widget _addressPageWidget(List<_Address> addressNames, Function onTap, int page) {
    return ListView.builder(
        itemCount: addressNames.length,
        itemBuilder: (context, index) => InkBox(
          onTap: () {
            final maxPage = _tabKeys.length - 1;
            _isAddTab = page == maxPage;
            if (page == maxPage) {
              setState(() {
                _selectorOpacity = 0;
                _tabKeys.add(GlobalKey());
                _addresses.insert(_addresses.length - 1, addressNames[index].name);
              });

              if (_tabKeys.length >= 2) {
                WidgetsBinding.instance.addPostFrameCallback((_) {

//                  RenderBox slider = _sliderKey.currentContext.findRenderObject();
//                  Offset offset = slider.localToGlobal(Offset.zero);
//                  RenderBox lastAddTab = _tabKeys[_tabKeys.length - 1].currentContext.findRenderObject();
//                  double extraWidth = (lastAddTab.size.width - slider.size.width) / 2;
//                  double totalWidth = 0;
//                  for (int j = 0; j <= _tabKeys.length - 1; j++) {
//                    RenderBox tab = _tabKeys[j].currentContext.findRenderObject();
//                    totalWidth += tab.size.width;
//                  }
//                  final sliderAnimEndDx = totalWidth - extraWidth - slider.size.width - _slideLeftMargin;
//
//                  RenderBox lastTab = _tabKeys[_tabKeys.length - 1].currentContext.findRenderObject();
//                  final selectorTranslateXBegin = (lastAddTab.size.width - lastTab.size.width) / 2 + lastTab.size.width;
//
//                  _animation = Tween<double>(begin: offset.dx - _slideLeftMargin, end: sliderAnimEndDx).animate(_curvedAnimation);
//                  _selectorTranslateXAnim = Tween<double>(begin: -selectorTranslateXBegin, end: 0).animate(_curvedAnimation);
//                  _selectorTranslateXAnim..addStatusListener((state) {
//                    _selectorOpacity = 1;
//                    if (_animation.isCompleted) {
//                      _isAddTab = false;
//                    }
//                  });
//                  _controller.value = 0;
//                  _controller.forward();
                  moveSlider(_tabKeys[_tabKeys.length - 1], _tabKeys.length - 1, withSliderTitle: true);
                });
              }
            } else {
              // 修改地址
              setState(() {
                _addresses[page] = addressNames[index].name;
              });
            }

            _pageController.animateToPage(_previousPage + 1, duration: Duration(milliseconds: 500), curve: Curves.ease);


          },
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(addressNames[index].name),
          ),
        )
    );
  }

  List<Widget> _addressPageWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < _tabKeys.length; i++) {
      List<_Address> _province = [
        _Address("北京市_${i}", i),
        _Address("广东省_${i}", i),
        _Address("湖南省_${i}", i),
        _Address("贵州省_${i}", i),
        _Address("湖北省_${i}", i),
      ];
      widgets.add(_addressPageWidget(_province, null, i));
    }
    return widgets;
  }

  moveSlider(GlobalKey tabKey, int currentSliderBeforeTabsNum, {bool withSliderTitle = false}) {
    if (_controller.isAnimating) {
      return;
    }
    print("移动滑块");

    RenderBox slider = _sliderKey.currentContext.findRenderObject();
    Offset offset = slider.localToGlobal(Offset.zero);

    RenderBox currentTab = tabKey.currentContext.findRenderObject();
    double extraWidth = (currentTab.size.width - slider.size.width) / 2;
    double totalWidth = 0;
    for (int j = 0; j <= currentSliderBeforeTabsNum; j++) {
      RenderBox tab = _tabKeys[j].currentContext.findRenderObject();
      totalWidth += tab.size.width;
    }
    final sliderAnimEndDx = totalWidth - extraWidth - slider.size.width - _slideLeftMargin;

    if (withSliderTitle) {
      final selectorTranslateXBegin = (currentTab.size.width - currentTab.size.width) / 2 + currentTab.size.width;
      _selectorTranslateXAnim = Tween<double>(begin: -selectorTranslateXBegin, end: 0).animate(_curvedAnimation);
      _selectorTranslateXAnim..addStatusListener((state) {
        _selectorOpacity = 1;
        if (_animation.isCompleted) {
          _isAddTab = false;
        }
      });
    }

    _animation = Tween<double>(begin: offset.dx - _slideLeftMargin, end: sliderAnimEndDx).animate(_curvedAnimation);
    _selectorTranslateXAnim = _defaultSelectorTranslateXAnim;
    _controller.value = 0;
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this
    );

    _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.ease
    )..addStatusListener((state) {
    });

    _animation = Tween<double>(begin: 0, end: 10).animate(_curvedAnimation);
    _defaultSelectorTranslateXAnim = Tween<double>(begin: 0, end: 0).animate(_curvedAnimation);
    _selectorTranslateXAnim = _defaultSelectorTranslateXAnim;

    for (int i = 0; i < _addresses.length; i++) {
      _tabKeys.add(GlobalKey());
    }

    _pageController.addListener(() {
      final currentPage = _pageController.page.round();
      if (currentPage != _previousPage && !_isAddTab) {
//        print("切换页面, 当前页面：${currentPage}, ${_pageController.page}");

//        RenderBox currentTab = _tabKeys[currentPage].currentContext.findRenderObject();
//
//        RenderBox slider = _sliderKey.currentContext.findRenderObject();
//        Offset offset = slider.localToGlobal(Offset.zero);
//        double extraWidth = (currentTab.size.width - slider.size.width) / 2;
//        double totalWidth = 0;
//        for (int j = 0; j <= currentPage; j++) {
//          RenderBox tab = _tabKeys[j].currentContext.findRenderObject();
//          totalWidth += tab.size.width;
//        }
//        final sliderAnimEndDx = totalWidth - extraWidth - slider.size.width - _slideLeftMargin;
//        _animation = Tween<double>(begin: offset.dx - _slideLeftMargin, end: sliderAnimEndDx).animate(_curvedAnimation);
//        _selectorTranslateXAnim = Tween<double>(begin: 0, end: 0).animate(_curvedAnimation);
//        _controller.value = 0;
//        _controller.forward();

        moveSlider(_tabKeys[currentPage], currentPage);
      }
      _previousPage = currentPage;
//      print("curren page: ${_pageController.page}");
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox slider = _sliderKey.currentContext.findRenderObject();
      Size sliderSize = slider.size;
      RenderBox tabOne = _tabKeys[0].currentContext.findRenderObject();
      Size tabOneSize = tabOne.size;
      final leftMargin = (tabOneSize.width - sliderSize.width) / 2;
//      print("leftMargin: ${leftMargin}");
      setState(() {
        _slideLeftMargin = leftMargin;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    print("rebuild widget: ${_addresses}, key: ${_tabKeys}");
    return Column(
      // dx必需从0开始
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          overflow: Overflow.clip,
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _tabWidgets(),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: _slideLeftMargin + _animation.value,
                  child: Row(
                    children: <Widget>[
                      Container(
                        key: _sliderKey,
                        width: 30,
                        height: 2,
                        decoration: BoxDecoration(
                            color: Colors.red
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: _addressPageWidgets(),
          ),
        ),
      ],
    );
  }
}

class _Address {
  final String name;
  final int page;

  _Address(this.name, this.page);
}