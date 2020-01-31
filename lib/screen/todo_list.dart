import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/repo/data/todo_item.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// StoreBuilder (a Widget that receives the Store from the StoreProvider)
/// and StoreConnector (a very useful Widget that can be used instead of
/// the StoreBuilder as you can convert the Store into a ViewModel to build
/// the Widget tree and whenever the State in the Store is modified, the
/// StoreConnector will get rebuilt)
class ToDoListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
    /// 将Store构建View转化成用ViewModel构建View
    converter: (Store<AppState> store) => _ViewModel.create(store),
    builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
      appBar: AppBar(title: Text(viewModel.pageTitle)),
      body: ListView(
        children: viewModel.items.map((_ItemViewModel itemViewModel) => _createWidget(itemViewModel)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.onNewItem,
        child: Icon(Icons.add),
      ),
    ),
  );

  Widget _createWidget(_ItemViewModel viewModel) {
    if (viewModel is _ToDoItemViewModel) {
      return Row(
        children: <Widget>[
          Expanded(child: InkWell(child: Text(viewModel.title))),
          FlatButton(
            child: Icon(
              viewModel.deleteItemIcon,
              semanticLabel: viewModel.deleteItemTooltip,
            ),
            onPressed: viewModel.onDeleteItem,
          )
        ],
      );
    } else if (viewModel is _EmptyItemViewModel) {
      return Container(
        child: TextField(
          autofocus: true,
          onSubmitted: viewModel.onCreateItem,
          decoration: InputDecoration(
              hintText: viewModel.createItemToolTip
          ),
        ),
      );
    }
  }

}

class _ViewModel {
  final String pageTitle;
  final List<_ItemViewModel> items;
  final Function onNewItem;
  final String newItemToolTip;
  final IconData newItemIcon;

  _ViewModel(this.pageTitle, this.items, this.onNewItem, this.newItemToolTip, this.newItemIcon);

  factory _ViewModel.create(Store<AppState> store) {
    List<_ItemViewModel> items = store.state.toDos
        .map((ToDoItem item) => _ToDoItemViewModel(item.title, () {
          store.dispatch(RemoveItemAction(item));
          store.dispatch(SaveListAction());
        }, "Delete", Icons.delete) as _ItemViewModel)
        .toList();
    if (store.state.listState == ListState.ListWithNewItem) {
      items.add(_EmptyItemViewModel("Type in new item name", (String title) {
        store.dispatch(DisplayListOnlyAction());
        store.dispatch(AddItemAction(ToDoItem(title)));
        store.dispatch(SaveListAction());
      }, "Add") as _ItemViewModel);
    }
    return _ViewModel("ToDo", items, () => store.dispatch(DisplayListWithNewItemAction()), "add new to-do item", Icons.add);
  }
}

abstract class _ItemViewModel {}

@immutable
class _ToDoItemViewModel extends _ItemViewModel {
  final String title;
  final Function() onDeleteItem;
  final String deleteItemTooltip;
  final IconData deleteItemIcon;

  _ToDoItemViewModel(this.title, this.onDeleteItem, this.deleteItemTooltip, this.deleteItemIcon);
}

@immutable
class _EmptyItemViewModel extends _ItemViewModel {
  final String hint;
  final Function(String) onCreateItem;
  final String createItemToolTip;

  _EmptyItemViewModel(this.hint, this.onCreateItem, this.createItemToolTip);
}