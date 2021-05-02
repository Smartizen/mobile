import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Redux/action.dart';

class ModalMemberFit extends StatelessWidget {
  const ModalMemberFit({Key key, @required this.manageId}) : super(key: key);

  final String manageId;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Xóa thành viên này'),
            leading: Icon(Icons.delete),
            onTap: () => deleteManage(context, manageId),
          )
        ],
      ),
    ));
  }

  deleteManage(context, manageId) async {
    final store = StoreProvider.of<AppState>(context);

    await store.dispatch(deleteManageAction(context, manageId));
    Navigator.of(context).pop();
  }
}
