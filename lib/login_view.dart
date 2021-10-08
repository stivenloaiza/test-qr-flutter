import 'package:flutter/material.dart';
class LoginView extends StatefulWidget {
  LoginView({Key? key, required this.result}) : super(key: key);
  String result;
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Container(
          child: Text(widget.result),
        ),
      )
    );
  }
}
