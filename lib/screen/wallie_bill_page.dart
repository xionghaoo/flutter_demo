import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/network.dart';
import 'package:flutter_demo/core/network_widget.dart';
import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class WallieBillPage extends StatefulWidget {
  @override
  _WallieBillPageState createState() => _WallieBillPageState();
}

class _WallieBillPageState extends State<WallieBillPage> {

  RefreshController _refreshController = RefreshController(
      initialRefresh: false);
//  bool _isInit = true;
  void _onRefresh() async {
    // monitor network fetch
//    print("_onRefresh start");
    await Future.delayed(Duration(milliseconds: 1000));
//    print("_onRefresh end ");
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    print("_onLoading start");
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length+1).toString());
    print("_onLoading end");
    if (mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

//  Future<void> _loadData() async {
//    setState(() {
//      _status = Status.loading;
//    });
//    await Future.delayed(Duration(seconds: 2));
//  }

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
          Text("Bill", style: TextStyle(color: Colors.green[500],
              fontSize: 20,
              fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }

  Widget _itemView(int index, String item) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("${index + 1} Jan 2020", style: TextStyle(
                  color: Colors.green[500],
                  fontWeight: FontWeight.w500,
                  fontSize: 15),),
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
                  Text("Netfix",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),),
                  Text("\$10.00", style: TextStyle(color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),)
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
          Divider(color: Color.fromRGBO(200, 200, 200, 0.5),
            endIndent: 10,
            thickness: 0.3,)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    _loadData().then((_) {
//      setState(() {
//        _status = Status.success;
//      });
//    }).catchError((e) => print(e));
//    StoreProvider.of<AppState>(context).dispatch(WallieBillAction);
  }

  @override
  Widget build(BuildContext context) =>
    StoreConnector<AppState, _ViewModel>(
      // 首次加载
      onInit: (Store<AppState> store) => store.dispatch(WallieBillAction(context, ApiResponse(Status.none))),
      // 首先触发初始化的Store，然后触发WallieBillAction的Store
      converter: (Store<AppState> store) => _ViewModel.create(store, context, _refreshController),
      builder: (BuildContext context, _ViewModel viewModel) =>
        Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _toolbar(),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: _refreshController,
                    onRefresh: () => viewModel.refresh(),
                    header: WaterDropHeader(),
                    child: viewModel.items.isEmpty
                        ? Center(child: CircularProgressIndicator(),)
                        : ListView.builder(
                      itemCount: viewModel.items.length,
                      itemBuilder: (context, index) => _itemView(index, viewModel.items[index])
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
}

// 当前页面的ViewModel
class _ViewModel {
  final List<String> items;
  final Status status;
  final Function refresh;

  _ViewModel(this.items, this.status, this.refresh);

  factory _ViewModel.create(Store<AppState> store, BuildContext context, RefreshController controller) {
    print("data = ${store.state.billState.response.data}");
    List<String> data = [];
    if (store.state.billState.response.data != null) {
      data = store.state.billState.response.data;
    }
    if (store.state.billState.response.status == Status.success) {
      print("load success");
      controller.refreshCompleted();
    }
    if (store.state.billState.response.status == Status.failure) {
      print("load failure");
      controller.refreshFailed();
    }
    return _ViewModel(
      data,
      store.state.billState.response.status,
      // data缓存
      () => store.dispatch(WallieBillAction(context, ApiResponse(Status.none, data: data))),
    );
  }
}