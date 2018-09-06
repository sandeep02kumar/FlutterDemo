import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/DataClass/MyProfileData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key key}) : super(key: key);

  static String tag = 'myprofile';

  @override
  MyProfileState createState() => new MyProfileState();
}

String _radioValue;

class MyProfileState extends State<MyProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MyProfileData _myProfileData;
  var _imagePic;
  String _teacherId;
  static String editable;
  var _pickedImage;

  final TextEditingController _firstNameController = new TextEditingController();
  final TextEditingController _middleNameController = new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _dateOfBirthController = new TextEditingController();
  final TextEditingController _addressOneController = new TextEditingController();
  final TextEditingController _addressTwoController = new TextEditingController();
  final TextEditingController _contactOneController = new TextEditingController();
  final TextEditingController _contactTwoController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSessionData();
  }

  _getSessionData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _teacherId = preferences.getString('user_id');

    _loadProfileData();
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_printLatestValue);
    _firstNameController.dispose();
    _middleNameController.removeListener(_printLatestValue);
    _middleNameController.dispose();
    _lastNameController.removeListener(_printLatestValue);
    _lastNameController.dispose();
    _emailController.removeListener(_printLatestValue);
    _emailController.dispose();
    _dateOfBirthController.removeListener(_printLatestValue);
    _dateOfBirthController.dispose();
    _addressOneController.removeListener(_printLatestValue);
    _addressOneController.dispose();
    _addressTwoController.removeListener(_printLatestValue);
    _addressTwoController.dispose();
    _contactOneController.removeListener(_printLatestValue);
    _contactOneController.dispose();
    _contactTwoController.removeListener(_printLatestValue);
    _contactTwoController.dispose();

    super.dispose();
  }

  _printLatestValue() {
    _firstNameController.text;
    _middleNameController.text;
    _lastNameController.text;
    _emailController.text;
    _dateOfBirthController.text;
    _addressOneController.text;
    _addressTwoController.text;
    _contactOneController.text;
    _contactTwoController.text;
  }

  Future _loadProfileData() async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_teacher_getMyProfile', body: {
      'teacher_id': _teacherId
    });
    if (response.statusCode == 200) {
      _myProfileData = new MyProfileData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }

    _firstNameController.addListener(_printLatestValue);
    _middleNameController.addListener(_printLatestValue);
    _lastNameController.addListener(_printLatestValue);
    _emailController.addListener(_printLatestValue);
    _addressOneController.addListener(_printLatestValue);
    _addressTwoController.addListener(_printLatestValue);
    _contactOneController.addListener(_printLatestValue);
    _contactTwoController.addListener(_printLatestValue);
    _dateOfBirthController.addListener(_printLatestValue);

    _middleNameController.text = _myProfileData.profileMiddleName;
    _firstNameController.text = _myProfileData.profileFirstName;
    _lastNameController.text = _myProfileData.profileLastName;
    _emailController.text = _myProfileData.profileUserEmail;
    _addressOneController.text = _myProfileData.profileAddressOne;
    _addressTwoController.text = _myProfileData.profileAddressTwo;
    _contactOneController.text = _myProfileData.profileContactOne;
    _contactTwoController.text = _myProfileData.profileContactTwo;
    _dateOfBirthController.text = _myProfileData.profileUserBirthDate;

    _radioValue = _myProfileData.profileUserGender;
    _imagePic = _myProfileData.profileUserProfile;
  }

  Future _updateMyProfile() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_editMyProfile', body: {
        'teacher_id': _teacherId,
        'first_name': _firstNameController.text,
        'middle_name': _middleNameController.text,
        'last_name': _lastNameController.text,
        'user_email': _emailController.text,
        'gender': _radioValue,
        'user_birth_date': _dateOfBirthController.text,
        'contact_no_first': _contactOneController.text,
        'contact_no_second': _contactTwoController.text,
        'address_first': _addressOneController.text,
        'address_second': _addressTwoController.text,
        'user_picture': '',
      });

      if (response.statusCode == 200) {
        String _msg = 'Profile updated successfully.';
        _showSnackBar(_msg);
      } else if (response.statusCode == 400) {
        return {"error": "Bad request"};
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      }
    } catch (err) {
      return {"error": err};
    }
  }

  var _dateFinal;

  Future<Null> _openDateDialog() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2050));

    if (picked != null) {
      setState(() {
        _dateFinal = picked;
        var strDate = picked.toString().substring(0, 10);
        _dateOfBirthController.text = strDate;
      });
    }
  }

  File _imageFile;

  Future _getImage() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = _image;
    });
  }

  void _showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: new Form(
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                new GestureDetector(
                  onTap: () {
                    _getImage();
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Positioned(
                        child: new Hero(
                          tag: 'hero',
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 48.0,
                            child: _imagePic == null ?
                            new Image.asset('assets/ic_launcher_launch.png') :
                            Image.network(
                                'http://182.72.79.154/p1136/media/front/img/user-profile-pictures/' +
                                    _imagePic),
                          ),
                        ),
                      ),
                      new Positioned(
                          right: 35.0,
                          bottom: 5.0,
                          child: Icon(Icons.camera_alt)),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'First Name',
                      labelText: 'First name'
                  ),
                  keyboardType: TextInputType.text,
                  controller: _firstNameController,
                  enabled: editable == "edit" ?
                  true : false,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Middle Name',
                      labelText: 'Middle name'
                  ),
                  keyboardType: TextInputType.text,
                  controller: _middleNameController,
                  enabled: false,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Last Name',
                      labelText: 'Last name'
                  ),
                  keyboardType: TextInputType.text,
                  controller: _lastNameController,
                  enabled: false,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                      labelText: 'Email'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  enabled: false,
                ),

                const SizedBox(height: 20.0),
                new GestureDetector(
                  onTap: () {
                    _openDateDialog();
                  },
                  child: new Container(
                    constraints: new BoxConstraints.expand(
                        height: 60.0
                    ),

                    child: new Stack(
                      children: <Widget>[
                        new Positioned(
                          child:
                          new TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Date Of Birth',
                            ),
                            enabled: false,
                            controller: _dateOfBirthController,
                          ),
                        ),
                        new Positioned(
                          right: 10.0,
                          top: 15.0,
                          child: new Icon(Icons.date_range),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Gender'),
                    new Radio(value: '1',
                      groupValue: _radioValue,
                      onChanged: (String str) {
                        setState(() {
                          _radioValue = str;
                        });
                      },
                    ),
                    new Text('Male'),

                    new Radio(
                      value: '2',
                      groupValue: _radioValue,
                      onChanged: (String str) {
                        setState(() {
                          _radioValue = str;
                        });
                      },
                    ),
                    new Text('Female'),
                  ],
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Class',
                    labelText: 'Class',
                  ),
                  enabled: false,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Address 1',
                    labelText: 'Address 1',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _addressOneController,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Address 2',
                    labelText: 'Address 2',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _addressTwoController,
                ),

                const SizedBox(height: 20.0),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Mobile 1',
                          labelText: 'Mobile 1',
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _contactOneController,
                      ),
                      flex: 1,
                    ),

                    const SizedBox(width: 10.0),
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Mobile 2',
                          labelText: 'Mobile 2',
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        controller: _contactTwoController,
                      ),
                      flex: 1,
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                new Material(
                  borderRadius: BorderRadius.circular(10.0),
                  shadowColor: Colors.lightBlueAccent,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 400.0,
                    height: 40.0,
                    onPressed: () {
                      _updateMyProfile();
                    },
                    color: Colors.blue,
                    child: Text(
                      'UPDATE PROFILE',
                      style: TextStyle(color: Colors.white),),
                  ),
                ),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}