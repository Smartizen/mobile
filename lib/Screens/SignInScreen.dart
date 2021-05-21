import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, state) {
                    return ListView(
                      children: <Widget>[
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/App.png'))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.email), onPressed: null),
                              Expanded(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(right: 20, left: 10),
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
                              IconButton(
                                  icon: Icon(Icons.lock), onPressed: null),
                              Expanded(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            hintText: 'Mật khẩu'),
                                      ))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                                  signIn(emailController.text,
                                      passwordController.text);
                                },
                                color: Color(0xFF00a79B),
                                child: Text(
                                  'ĐĂNG NHẬP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'SignUp');
                          },
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Bạn chưa có tài khoản ?',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: ' ĐĂNG KÝ',
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                            ),
                          ),
                        )
                      ],
                    );
                  })),
    );
  }

  signIn(String email, pass) async {
    final store = StoreProvider.of<AppState>(context);

    await store.dispatch(signin(context, email, pass));

    setState(() {
      _isLoading = false;
    });
  }
}
