import 'package:flutter/material.dart';
import 'package:smartizen/utils/app_color.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Redux/action.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

enum Gender { MALE, FEMALE }

class _UpdateProfileState extends State<UpdateProfile> {
  void initState() {
    super.initState();
  }

  // Gender _genderValue = Gender.MALE;
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroud,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackgroud,
          title: Text("Cập nhật trang cá nhân"),
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.person, color: Colors.white),
                            onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 10, left: 10),
                                child: TextFormField(
                                  controller: firstNameController,
                                  style: TextStyle(color: AppColors.fontColor),
                                  decoration: InputDecoration(
                                    hintText: state.user["firstname"].length > 0
                                        ? state.user["firstname"]
                                        : 'Họ',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                  right: 20,
                                ),
                                child: TextFormField(
                                  // initialValue: ,
                                  controller: lastNameController,
                                  style: TextStyle(color: AppColors.fontColor),
                                  decoration: InputDecoration(
                                    hintText: state.user["lastname"].length > 0
                                        ? state.user["lastname"]
                                        : 'Tên',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.email, color: Colors.white),
                            onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: TextFormField(
                                  controller: emailController,
                                  style: TextStyle(color: AppColors.fontColor),
                                  decoration: InputDecoration(
                                    hintText: state.user["email"].length > 0
                                        ? state.user["email"]
                                        : 'Email',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.phone, color: Colors.white),
                            onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: TextFormField(
                                  controller: phoneNumberController,
                                  style: TextStyle(color: AppColors.fontColor),
                                  decoration: InputDecoration(
                                      hintText: state.user["phonenumber"] !=
                                                  null &&
                                              state.user["phonenumber"].length >
                                                  0
                                          ? state.user["phonenumber"]
                                          : 'Số điện thoại',
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                )))
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Expanded(
                  //         child: RadioListTile(
                  //           title: Text(
                  //             'Nam',
                  //             style: TextStyle(
                  //                 fontFamily: "SF Rounded",
                  //                 fontSize: 21,
                  //                 color: AppColors.fontColor),
                  //           ),
                  //           value: Gender.MALE,
                  //           groupValue: _genderValue,
                  //           onChanged: (Gender value) {
                  //             setState(() {
                  //               _genderValue = value;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: RadioListTile(
                  //           title: Text(
                  //             "Nữ",
                  //             style: TextStyle(
                  //                 fontFamily: "SF Rounded",
                  //                 fontSize: 21,
                  //                 color: AppColors.fontColor),
                  //           ),
                  //           value: Gender.FEMALE,
                  //           groupValue: _genderValue,
                  //           onChanged: (Gender value) {
                  //             setState(() {
                  //               _genderValue = value;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            // setState(() {
                            //   _isLoading = true;
                            // });
                            updateProf(
                              firstNameController.text,
                              lastNameController.text,
                              emailController.text,
                              phoneNumberController.text,
                            );
                          },
                          color: Color(0xFF00a79B),
                          child: Text(
                            'Cập Nhật',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }

  updateProf(String firstname, lastname, email, phonenumber) async {
    final store = StoreProvider.of<AppState>(context);

    await store.dispatch(
        updateProfile(context, firstname, lastname, email, phonenumber));

    completeDialog();
  }

  completeDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Thành công"),
            content: Text("Thay đổi thông tin thành công"),
            backgroundColor: Colors.white,
            elevation: 24.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
          );
        });
  }
}
