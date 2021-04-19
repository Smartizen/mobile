import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';

enum Gender { MALE, FEMALE }

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  Gender _genderValue = Gender.MALE;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  BackButtonWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.mail), onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration:
                                      InputDecoration(hintText: 'Email'),
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.lock), onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(hintText: 'Password'),
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.person), onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 10, left: 10),
                                child: TextFormField(
                                  controller: firstNameController,
                                  decoration:
                                      InputDecoration(hintText: 'First Name'),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                  right: 20,
                                ),
                                child: TextFormField(
                                  controller: lastNameController,
                                  decoration:
                                      InputDecoration(hintText: 'Last Name'),
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            title: const Text('Male'),
                            value: Gender.MALE,
                            groupValue: _genderValue,
                            onChanged: (Gender value) {
                              setState(() {
                                _genderValue = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: const Text('Female'),
                            value: Gender.FEMALE,
                            groupValue: _genderValue,
                            onChanged: (Gender value) {
                              setState(() {
                                _genderValue = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Radio(value: null, groupValue: null, onChanged: null),
                  //       RichText(
                  //           text: TextSpan(
                  //               text: 'I have accepted the',
                  //               style: TextStyle(color: Colors.black),
                  //               children: [
                  //             TextSpan(
                  //                 text: 'Terms & Condition',
                  //                 style: TextStyle(
                  //                     color: Colors.teal,
                  //                     fontWeight: FontWeight.bold))
                  //           ]))
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 60,
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            signUp(
                                emailController.text,
                                passwordController.text,
                                firstNameController.text,
                                lastNameController.text,
                                _genderValue);
                          },
                          color: Color(0xFF00a79B),
                          child: Text(
                            'SIGN UP',
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
              ),
      ),
    );
  }

  signUp(String email, password, firstname, lastname, gender) async {
    final store = StoreProvider.of<AppState>(context);

    await store.dispatch(
        signup(context, email, password, firstname, lastname, gender));

    setState(() {
      _isLoading = false;
    });
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/App.png'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Create New Account',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}
