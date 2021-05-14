import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Screens/Notification/Component/notification_list.dart';
import 'package:smartizen/utils/app_color.dart';
import 'package:smartizen/Redux/action.dart';

class NotificationBox extends StatefulWidget {
  @override
  _NotificationBoxState createState() => _NotificationBoxState();
}

class _NotificationBoxState extends State<NotificationBox> {
  bool _isLoading = true;

  fetchNotification(store) async {
    await store.dispatch(getNotification(context));

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroud,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackgroud,
          title: Text("Thông báo"),
        ),
        body: StoreConnector<AppState, AppState>(
            onInit: (store) {
              fetchNotification(store);
            },
            converter: (store) => store.state,
            builder: (context, state) {
              return _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return NotificationList(
                                    id: state
                                        .notifications.notifications[index].id,
                                    title: state.notifications
                                        .notifications[index].title,
                                    body: state.notifications
                                        .notifications[index].body,
                                    createdAt: state.notifications
                                        .notifications[index].created_at);
                              },
                              itemCount:
                                  state.notifications.notifications.length),
                        ),
                      ],
                    );
            }));
  }
}
