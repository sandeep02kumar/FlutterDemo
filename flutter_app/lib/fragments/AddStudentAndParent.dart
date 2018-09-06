import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/DataClass/ClassData.dart';
import 'package:flutter_app/DataClass/SectionData.dart';
import 'package:flutter_app/DataClass/SubjectData.dart';
import 'package:flutter_app/PasswordField.dart';

class AddStudentAndParent extends StatefulWidget {
  AddStudentAndParent({Key key}) : super(key: key);

  @override
  _AddStudentAndParentState createState() => new _AddStudentAndParentState();
}

String _radioValue;

class _AddStudentAndParentState extends State<AddStudentAndParent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = new GlobalKey<
      FormFieldState<String>>();

  ClassData _classData;
  SectionData _sectionData;
  SubjectData _subjectData;
  String _teacherId;
  String _schoolId;
  String _mySelection;
  String _mySelection2;
  var _pickedImage;
  String mStrId = '';
  static bool isCheck;
  List<arraySubject> _listSubjects = [];
  bool _formWasEdited = false;
  bool _autoValidate = false;

  final TextEditingController _firstNameController = new TextEditingController();
  final TextEditingController _middleNameController = new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _dateOfBirthController = new TextEditingController();
  final TextEditingController _addressOneController = new TextEditingController();
  final TextEditingController _addressTwoController = new TextEditingController();
  final TextEditingController _contactOneController = new TextEditingController();
  final TextEditingController _contactTwoController = new TextEditingController();
  final TextEditingController _parentNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();
  final TextEditingController _subjectController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSessionData();
  }

  _getSessionData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _teacherId = preferences.getString('user_id');
    _schoolId = preferences.getString('school_id');
    _getClassList();
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
    _parentNameController.removeListener(_printLatestValue);
    _parentNameController.dispose();
    _passwordController.removeListener(_printLatestValue);
    _passwordController.dispose();
    _confirmPasswordController.removeListener(_printLatestValue);
    _confirmPasswordController.dispose();
    _subjectController.removeListener(_printLatestValue);
    _subjectController.dispose();

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
    _parentNameController.text;
    _passwordController.text;
    _confirmPasswordController.text;
    _subjectController.text;
  }

  Future _getClassList() async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_class_list', body: {
      'school_id': _schoolId,
      'teacher_id': _teacherId
    });
    if (response.statusCode == 200) {
      setState(() {
        _classData = new ClassData.fromJson(json.decode(response.body));
      });
    }
  }

  Future _getSectionList(String value) async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_getSectionListByClass', body: {
      'school_id': _schoolId,
      'class_id': value
    });
    if (response.statusCode == 200) {
      setState(() {
        _sectionData = new SectionData.fromJson(json.decode(response.body));
      });
    }
  }

  Future _getClassSubjectList(String _value) async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_getClassWiseSubject_list', body: {
      'school_id': _schoolId,
      'section_id': _value,
      'class_id': _mySelection
    });
    if (response.statusCode == 200) {
      if (response.body != null) {
        _subjectData = new SubjectData.fromJson(json.decode(response.body));
      }

      setState(() {
        _listSubjects = _subjectData.listSubject as List;
      });
    }
  }

  Future _addStudentAndParentProfile() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_student_registration', body: {
        'user_id': _teacherId,
        'school_id': _schoolId,
        'first_name': _firstNameController.text,
        'middle_name': _middleNameController.text,
        'last_name': _lastNameController.text,
        'user_email': _emailController.text,
        'password': _passwordController.text,
        'parent_name': _parentNameController.text,
        'gender': _radioValue,
        'user_birth_date': _dateOfBirthController.text,
        'address_first': _addressOneController.text,
        'address_second': _addressTwoController.text,
        'contact_no_first': _contactOneController.text,
        'contact_no_second': _contactTwoController.text,
        'class_id': _mySelection,
        'user_picture': '',
        'subject_id': mStrId,
        'section_id': _mySelection2
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

    _firstNameController.addListener(_printLatestValue);
    _middleNameController.addListener(_printLatestValue);
    _lastNameController.addListener(_printLatestValue);
    _emailController.addListener(_printLatestValue);
    _addressOneController.addListener(_printLatestValue);
    _addressTwoController.addListener(_printLatestValue);
    _contactOneController.addListener(_printLatestValue);
    _contactTwoController.addListener(_printLatestValue);
    _dateOfBirthController.addListener(_printLatestValue);
    _parentNameController.addListener(_printLatestValue);
    _passwordController.addListener(_printLatestValue);
    _confirmPasswordController.addListener(_printLatestValue);
  }

  var _dateFinal;

  Future<Null> _openDateDialog() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime.now());

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

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Phone no. is required.';
    final RegExp phoneExp = new RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value))
      return '(###) ###-#### - Enter a US phone number.';
    return null;
  }

  /*String _validateMiddleName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Middle name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }*/

  String _validateLastName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Last name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateParentName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Parent name is required.';
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';*/
    return null;
  }

  String _validateDateOfBirth(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Date of birh is required.';
    /* final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';*/
    return null;
  }

  String _validateEmail(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Email is required.';
    return null;
  }

  /*String _validateAddressOne(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Address one is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateAddressTwo(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Address two is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }*/

  String _validatePassword(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Password is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateConfirmPassword(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Confirm password is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  void _handleSubmittedData() {
    final FormState formState = _formKey.currentState;
    if (!formState.validate()) {
      _autoValidate = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      _addStudentAndParentProfile();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  Future<bool> _openSubjectDialog() async {
    return await showDialog(context: context,
        builder: (BuildContext context) {
          return new Dialog(
            child: new SingleChildScrollView(
              child: new Container(
                width: 100.0,
                height: 200.0,
                color: Colors.white70,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Expanded(
                      child: new ListView(
                        children: _listSubjects.map((arraySubject subj) {
                          return new CheckboxListTile(
                            title: new Text(subj.subjectTitle),
                            value: subj.isCheck,
                            onChanged: (bool value) {
                              setState(() {
                                subj.isCheck = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    new RaisedButton(
                        child: new Text('Save'),
                        onPressed: () {
                          mStrId = "";
                          for (arraySubject as in _listSubjects) {
                            if (as.isCheck) {
                              if (mStrId != '') {
                                mStrId += ',';
                                _subjectController.text += ',';
                              }
                              mStrId = as.subjectId;
                              _subjectController.text = as.subjectTitle;
                            } else {
                              _subjectController.text = "";
                            }
                          }
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
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
                            child: _imageFile == null ?
                            new Image.asset('assets/ic_launcher_launch.png') :
                            Image.file(_imageFile),
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
                  validator: _validateName,
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
                  //validator: _validateMiddleName
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
                    validator: _validateLastName
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Parent Name',
                        labelText: 'Parent name'
                    ),
                    keyboardType: TextInputType.text,
                    controller: _parentNameController,
                    validator: _validateParentName
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
                              validator: _validateDateOfBirth
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
                new TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        labelText: 'Email'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _validateEmail
                ),

                const SizedBox(height: 20.0),
                new Column(
                  children: <Widget>[
                    new DropdownButton<String>(
                      hint: new Text('Select Class'),
                      value: _mySelection,
                      onChanged: (String value) {
                        setState(() {
                          _mySelection = value;
                          _getSectionList(value);
                        });
                      },
                      items: _classData.listClass != null ?
                      _classData.listClass.map((ClassArray arrClass) {
                        return new DropdownMenuItem<String>(
                            value: arrClass.classId,
                            child: new Text(arrClass.classTitle));
                      },).toList() : <String>[''].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                new Column(
                  children: <Widget>[
                    new DropdownButton<String>(
                      hint: new Text('Select Section'),
                      value: _mySelection2,
                      onChanged: (String value) {
                        setState(() {
                          _mySelection2 = value;
                          _getClassSubjectList(value);
                        });
                      },
                      items: _mySelection != null ?
                      _sectionData.listSection.map((ArraySection arrSection) {
                        return DropdownMenuItem<String>(
                            value: arrSection.sectionId,
                            child: new Text(arrSection.sectionTitle));
                      }).toList() : <String>[''].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                new GestureDetector(
                  onTap: () {
                    _openSubjectDialog();
                  }, child: new Stack(
                  children: <Widget>[
                    new TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Class Subject',
                        labelText: 'Class Subject',
                      ),
                      controller: _subjectController,
                      enabled: false,),
                    new Positioned(
                        right: 30.0,
                        top: 15.0,
                        child: new Icon(Icons.map)),
                  ],
                ),
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
                  // validator: _validateAddressOne
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
                  //  validator: _validateAddressTwo
                ),

                const SizedBox(height: 20.0),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Contact 1',
                          labelText: 'Contact 1',
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _contactOneController,
                        // validator: _validatePhoneNumber
                      ),
                      flex: 1,
                    ),

                    const SizedBox(width: 10.0),
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Contact 2',
                          labelText: 'Contact 2',
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        controller: _contactTwoController,
                        // validator: _validatePhoneNumber
                      ),
                      flex: 1,
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                new PasswordField(
                  fieldKey: _passwordFieldKey,
                  hintText: "Password",
                  labelText: 'Password',
                  controller: _passwordController,
                  validator: _validatePassword,
                  onFieldSubmitted: (String value) {
                    setState(() {
                      //person.password = value;
                    });
                  },
                ),

                const SizedBox(height: 20.0),
                new PasswordField(
                  // fieldKey: _passwordFieldKey1,
                  hintText: "Confirm Password",
                  labelText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (String value) {
                    setState(() {
                      //person.password = value;
                    });
                  },
                ),

                /*const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  validator: _validatePassword,
                  obscureText: true,
                ),*/

                /*const SizedBox(
                    height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _confirmPasswordController,
                  validator: _validateConfirmPassword,
                  obscureText: true,
                ),*/

                const SizedBox(height: 20.0),
                new Material(
                  borderRadius: BorderRadius.circular(10.0),
                  shadowColor: Colors.lightBlueAccent,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 400.0,
                    height: 40.0,
                    onPressed: () {
                      _handleSubmittedData();
                    },
                    color: Colors.blue,
                    child: Text(
                      'SAVE', style: TextStyle(color: Colors.white),),
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