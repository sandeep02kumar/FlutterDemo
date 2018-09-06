import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/TextFormFieldDemo.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/DataClass/StudentInfo.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  const LoginPage({ Key key }) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  StudentInfo _StudentInfo;
  bool _formEdited = false;

  String _email;
  String _pass;

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  void _submit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _login(_email, _pass);
      _showInSnackBar('${_email},${_pass}');
    }
  }

  Future _login(String email, String password) async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_login', body: {
        'email_id': email,
        'password': password,});

      if (response.statusCode == 200) {
        final jsonRes = json.decode(response.body);
        _StudentInfo = new StudentInfo.fromJson(jsonRes);

        _addDataToSession();
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => Dashboard()));
      }
      else {
        throw Exception('Failed');
      }
    }
    catch (err) {
      print(err.toString());
    }
  }

  _addDataToSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('user_name', _StudentInfo.stdUserName);
      preferences.setString('user_profile', _StudentInfo.stdUserProfile);
      preferences.setString('user_id', _StudentInfo.stdUserId);
      preferences.setString('school_id', _StudentInfo.stdUserSchoolId);
    });
  }

  String _validateEmail(String value) {
    _formEdited = true;
    if (value.isEmpty)
      return 'Please enter email.';
    return null;
  }

  String _validatePassword(String value) {
    _formEdited = true;
    if (value.isEmpty)
      return 'Please enter password';
    return null;
  }

  Future<bool> _openDialogForgotPass() async {
    return await showDialog<bool>(context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: const Text(
            'if you have forgotten your password, enter your email address below and we will send you an security code and instructions.',
            style: TextStyle(color: Colors.black),),
          children: <Widget>[
            const SizedBox(height: 20.0),
            new TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                icon: Icon(Icons.email),
                hintText: 'User e-mail',
                labelText: 'E-mail',
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: (String value) {
                _email = value;
              },
              validator: _validateEmail,
            ),
            const SizedBox(height: 20.0),
            new Center(
              child: new RaisedButton(
                onPressed: () {},
                child: const Text('Send'),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/ic_launcher_launch.png'),
      ),
    );

    /* final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: 'sandy@gmail.com',
      decoration: InputDecoration(
        hintText: 'Enter your email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: 'password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 40.0,
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.tag);
          },
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white),),
        ),
      ),
    );*/

    final forgotPassword = FlatButton(
      child: Text('Forgot Password?', style: TextStyle(color: Colors.black54),),
      onPressed: () {
        _openDialogForgotPass();
      },
    );

    final signUp = FlatButton(
      child: Text('Sign Up', style: TextStyle(color: Colors.lightBlue),),
      onPressed: () {
        Navigator.of(context).pushNamed(TextFormFieldDemo.tag);
      },
    );


    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              child: new SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 100.0),
                    logo,
                    const SizedBox(height: 24.0),
                    new TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.email),
                        hintText: 'User e-mail',
                        labelText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String value) {
                        _email = value;
                      },
                      validator: _validateEmail,
                    ),

                    const SizedBox(height: 24.0),
                    new TextFormField(
                      maxLength: 10,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.remove_red_eye),
                          hintText: 'Password',
                          labelText: 'Password'
                      ),
                      onSaved: (String value) {
                        _pass = value;
                      },
                      validator: _validatePassword,
                    ),

                    const SizedBox(height: 24.0),
                    new Center(
                      child: RaisedButton(
                          child: const Text('Log In',
                            style: TextStyle(color: Colors.black),),
                          onPressed: _submit),
                    ),
                    const SizedBox(height: 24.0),
                    forgotPassword,
                    signUp
                  ],
                ),
              ))),
    );

    /*  return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Text fields'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 30.0),
            email,
            SizedBox(height: 30.0),
            password,
            SizedBox(height: 30.0),
            loginButton,
            forgotPassword,
            signUp
          ],
        ),
      ),
    );*/
  }
}