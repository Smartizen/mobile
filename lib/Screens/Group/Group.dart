import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Screens/Group/Component/Member.dart';
import 'package:smartizen/utils/app_color.dart';

class Group extends StatefulWidget {
  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  Future<String> addMember(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    TextEditingController email = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Nhập email"),
            backgroundColor: Colors.blueGrey[50],
            content: TextField(
              controller: email,
              decoration:
                  InputDecoration(hintText: "ví dụ : NguyenVanA@gmail.com"),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Gửi"),
                onPressed: () {
                  store.dispatch(addNewMember(context, email.text));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroud,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroud,
        title: Text("Thành viên"),
      ),
      floatingActionButton: Transform.scale(
        scale: 1.1,
        child: Transform.translate(
          offset: Offset(0, 18),
          child: GestureDetector(
            onTap: () {
              addMember(context);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 30, right: 20),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(0.5, 0),
                      end: Alignment(0.5, 1),
                      colors: [Color(0xff7afc79), Color(0xff3ccb97)]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 18,
                        color: Color(0xff7afc79).withOpacity(0.26))
                  ]),
              child: Image.asset(
                'assets/plus.png',
              ),
            ),
          ),
        ),
      ),
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Member(
                              id: state.members.members[index].id,
                              firstname: state.members.members[index].firstname,
                              lastname: state.members.members[index].lastname,
                              email: state.members.members[index].email,
                              role: state.members.members[index].role,
                              manageId: state.members.members[index].manageId);
                        },
                        itemCount: state.members.members.length),
                  )
                ]);
          }),
    );
  }
}
