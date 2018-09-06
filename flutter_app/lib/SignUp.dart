import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
 // static String tag = 'sign-up-page';

  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final SignUpPage = Hero(
      tag: 'hero',
      child: Padding(padding: EdgeInsets.all(16.0),
        child: Text(''
        ),
      ),
    );

    final firstName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter your first name.',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final lastName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter your last name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final emailAddress = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter your email address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final phoneNo = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter your phone no.',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sign Up"),),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SignUpPage,
            SizedBox(height: 30.0),
            firstName,
            SizedBox(height: 30.0),
            lastName,
            SizedBox(height: 30.0),
            emailAddress,
            SizedBox(height: 30.0),
            phoneNo,
          ],
        ),
      ),
      /*body: Center(
        child: RaisedButton(onPressed: () {
          Navigator.pop(context);
        },
          child: body,
        ),
      ),*/
    );
  }
}