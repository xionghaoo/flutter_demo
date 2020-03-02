import 'package:flutter/material.dart';

import 'common_widgets.dart';

@immutable
class CascadeSelectorWidget extends StatefulWidget {
  
  final List<List<String>> data;
  final Function(String address) completeCallBack;
  final int maxTabsNum;

  CascadeSelectorWidget(this.data, {this.maxTabsNum = 4, this.completeCallBack});

  @override
  _CascadeSelectorWidgetState createState() => _CascadeSelectorWidgetState();
}

class _CascadeSelectorWidgetState extends State<CascadeSelectorWidget> with SingleTickerProviderStateMixin {

  int _maxTabsNum = 4;

  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Animation _sliderAnimation;
  Animation _tabTitleTranslateXAnim;
  Animation _defaultTabTitleTranslateXAnim;
  
  GlobalKey _sliderKey = GlobalKey();
  List<GlobalKey> _tabKeys = [];
  
  PageController _pageController = PageController(initialPage: 0);

  double _slideLeftMargin = 0;
  double _tabTitleOpacity = 1;

  int _previousPage = 0;
  bool _isAddTab = false;

  List<String> _tabNames = ["请选择"];

  Widget _tabItemWidget(Function(int) onTap, Key key, String content, int index) {
    return InkBox(
      onTap: () {onTap(index);},
      child: Container(
        key: key,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(content, style: TextStyle(color: index == _tabKeys.length - 1 ? Colors.red : Colors.black),),
        ),
      ),
    );
  }

  List<Widget> _tabWidgets() {
    List<Widget> tabs = [];
    for (int i = 0; i < _tabKeys.length; i++) {
      final onTap = (index) {
        if (_previousPage != index) {
          moveSlider(_tabKeys[i], i);
        }

        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);

      };
      Widget widget = _tabItemWidget(onTap, _tabKeys[i], _tabNames[i], i);

      if (i == _tabKeys.length - 1 && _tabKeys.length >= 2) {
        widget = AnimatedBuilder(
          animation: _tabTitleTranslateXAnim,
          builder: (context, child) => Transform.translate(
            offset: Offset(_tabTitleTranslateXAnim.value, 0),
            child: Opacity(
              opacity: _tabTitleOpacity,
              child: _tabItemWidget(onTap, _tabKeys[i], _tabNames[i], i)
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

  Widget _selectPageItemWidget(List<String> addressNames, Function onTap, int page) {
    return ListView.builder(
        itemCount: addressNames.length,
        itemBuilder: (context, index) => InkBox(
          onTap: () {
            if (page >= widget.data.length - 1) {
              setState(() {
                _tabNames[page] = addressNames[index];
              });
              String completeAddress = "";
              for (int i = 0; i < _tabKeys.length; i++) {
                completeAddress += _tabNames[i];
              }
              widget.completeCallBack(completeAddress);
              resetSlider(_tabKeys[page]);
              return;
            }

            final maxPage = _tabKeys.length - 1;
            _isAddTab = page == maxPage;
            if (page == maxPage) {
              setState(() {
                _tabTitleOpacity = 0;
                _tabKeys.add(GlobalKey());
                _tabNames.insert(_tabNames.length - 1, addressNames[index]);
              });

              if (_tabKeys.length >= 2) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  moveSlider(_tabKeys[_tabKeys.length - 1], _tabKeys.length - 1, withSliderTitle: true);
                });
              }
            } else {
              // 修改地址
              setState(() {
                _tabNames[page] = addressNames[index];
              });
            }

            _pageController.animateToPage(_previousPage + 1, duration: Duration(milliseconds: 500), curve: Curves.ease);


          },
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(addressNames[index]),
          ),
        )
    );
  }

  List<Widget> _selectPageWidgets() {
    if (widget.data.length > _maxTabsNum) {
      throw Exception("级联选择器最多支持$_maxTabsNum级！");
    }
    List<Widget> widgets = [];
    for (int i = 0; i < widget.data.length; i++) {
      widgets.add(_selectPageItemWidget(widget.data[i], null, i));
    }
    return widgets;
  }

  /// 移动滑块到指定的tab
  void moveSlider(GlobalKey tabKey, int currentSliderBeforeTabsNum, {bool withSliderTitle = false}) {
    if (_controller.isAnimating) {
      return;
    }
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

    // 新增tab时移动标题，非新增时不移动
    if (withSliderTitle) {
      final selectorTranslateXBegin = (currentTab.size.width - currentTab.size.width) / 2 + currentTab.size.width;
      _tabTitleTranslateXAnim = Tween<double>(begin: -selectorTranslateXBegin, end: 0).animate(_curvedAnimation);
      _tabTitleTranslateXAnim.addStatusListener((state) {
        _tabTitleOpacity = 1;
        if (_sliderAnimation.isCompleted) {
          _isAddTab = false;
        }
      });
    } else {
      _tabTitleTranslateXAnim = _defaultTabTitleTranslateXAnim;
    }

    _sliderAnimation = Tween<double>(begin: offset.dx - _slideLeftMargin, end: sliderAnimEndDx).animate(_curvedAnimation);
    _controller.value = 0;
    _controller.forward();
  }
  
  /// 重置滑块在当前tab的位置
  void resetSlider(GlobalKey tabKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox slider = _sliderKey.currentContext.findRenderObject();
      Size sliderSize = slider.size;
      RenderBox tab = tabKey.currentContext.findRenderObject();
      Size tabSize = tab.size;
      final leftMargin = (tabSize.width - sliderSize.width) / 2;
      setState(() {
        _slideLeftMargin = leftMargin;
      });
    });
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

    _sliderAnimation = Tween<double>(begin: 0, end: 10).animate(_curvedAnimation);
    _defaultTabTitleTranslateXAnim = Tween<double>(begin: 0, end: 0).animate(_curvedAnimation);
    _tabTitleTranslateXAnim = _defaultTabTitleTranslateXAnim;

    for (int i = 0; i < _tabNames.length; i++) {
      _tabKeys.add(GlobalKey());
    }

    _pageController.addListener(() {
      final currentPage = _pageController.page.round();
      if (currentPage != _previousPage && !_isAddTab) {
        moveSlider(_tabKeys[currentPage], currentPage);
      }
      _previousPage = currentPage;
    });

    _maxTabsNum = widget.maxTabsNum;

    // 布局完成后调整滑块的位置
    resetSlider(_tabKeys[0]);
  }

  @override
  Widget build(BuildContext context) {
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
              animation: _sliderAnimation,
              builder: (context, child) {
                return Positioned(
                  left: _slideLeftMargin + _sliderAnimation.value,
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
            children: _selectPageWidgets(),
          ),
        ),
      ],
    );
  }
}