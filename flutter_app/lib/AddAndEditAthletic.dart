import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAndEditAthletic extends StatefulWidget {
  final String schoolId;
  final String athleticId;
  final String athleticTitle;
  final String athleticDesc;
  final String athleticTeacherId;
  final String image;
  final String flagType;

  AddAndEditAthletic({Key key,
    this.schoolId,
    this.athleticTitle,
    this.athleticDesc,
    this.athleticTeacherId,
    this.image,
    this.athleticId,
    this.flagType,
  }) :super(key: key);

  @override
  AddAndEditAthleticState createState() => AddAndEditAthleticState();
}

class AddAndEditAthleticState extends State<AddAndEditAthletic> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _sessionUserName;
  String _sessionSchoolId;
  String _sessionUserId;
  String _athleticTitle = "";
  String _athleticDesc = "";
  var _pickedImage;

  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _desController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _getSharedPreferenceData();
  }

  @override
  void dispose() {
    _titleController.removeListener(_printLatestValue);
    _titleController.dispose();
    _desController.removeListener(_printLatestValue);
    _desController.dispose();
    super.dispose();
  }

  _getSharedPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionUserId = prefs.getString('user_id');
      _sessionSchoolId = prefs.getString('school_id');
      _sessionUserName = prefs.getString('user_name');
    });

    _titleController.addListener(_printLatestValue);
    _desController.addListener(_printLatestValue);

    if (widget.flagType == 'Edit') {
      _titleController.text = widget.athleticTitle;
      _desController.text = widget.athleticDesc;
      // _pickedImage = widget.image;
    }
  }

  _printLatestValue() {
    _athleticTitle = _titleController.text;
    _athleticDesc = _desController.text;
  }

  Future _callWsAddAthletic() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_add_Athilatics', body: {
        'school_id': _sessionSchoolId,
        'teacher_id': _sessionUserName,
        'news_title': _athleticTitle,
        'news_description': _athleticDesc,
        'teacher_primary_key_id': _sessionUserId,
        'news_image': ''
      });

      if (response.statusCode == 200) {
        String msg = 'Athletic added successfully.';
        _showInSnackBar(msg);

        /*  Fluttertoast.showToast(
            msg: "Athletic added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            bgcolor: '#ffffff'
        );

        Navigator.pop(context, true);*/
      } else if (response.statusCode == 400) {
        return {"error": "Bad request"};
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      }
    } catch (err) {
      print(err.toString());
    }
  }


  Future _callWsEditAthletic() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_edit_Athilatics', body: {
        'school_id': _sessionSchoolId,
        'teacher_id': _sessionUserName,
        'news_title': _athleticTitle,
        'news_description': _athleticDesc,
        'teacher_primary_key_id': _sessionUserId,
        'news_image': '',
        'athilatic_id': widget.athleticId
      });

      if (response.statusCode == 200) {
        String msg = 'Athletic updated successfully.';
        _showInSnackBar(msg);

        /* Fluttertoast.showToast(
            msg: "Athletic updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            bgcolor: '#00FFFF',
            textcolor: '#000000'
          //  timeInSecForIos: 1
        );*/
        //  Navigator.pop(context, true);
      } else if (response.statusCode == 400) {
        return {"error": "Bad request"};
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future _imagePickerDialog() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        _pickedImage = _image;
      });
    }
  }

  void _showInSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
      action: SnackBarAction(label: 'OK', onPressed: () {
        Navigator.pop(context, true);
      }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: widget.flagType == 'Edit' ?
        new Text('Edit Athletic Detail', textAlign: TextAlign.center) :
        Text('Add Athletic Detail', textAlign: TextAlign.center),
      ),

      body: new SafeArea(
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: new Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                new GestureDetector(
                  onTap: () {
                    _imagePickerDialog();
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Positioned(
                        child: new CircleAvatar(
                          radius: 48.0,
                          backgroundColor: Colors.transparent,
                          child: _pickedImage == null ?
                          new Image.asset(
                              'assets/ic_launcher_launch.png')
                              : Image
                              .file( // 'http://182.72.79.154/p1136/media/backend/img/news_image/' +

                              _pickedImage),
                        ),
                      ),
                      new Positioned(
                        right: 35.0,
                        bottom: 5.0,
                        child: new Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Athletic Title',
                      labelText: 'Athletic Title'
                  ),
                  maxLines: 1,
                  controller: _titleController,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Athletic Description',
                      labelText: 'Athletic Description '
                  ),
                  controller: _desController,
                ),

                const SizedBox(height: 40.0),
                new Material(
                  borderRadius: BorderRadius.circular(10.0),
                  shadowColor: Colors.lightBlueAccent,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 400.0,
                    height: 40.0,
                    onPressed: () {
                      if (widget.flagType == 'Edit') {
                        _callWsEditAthletic();
                      } else {
                        _callWsAddAthletic();
                      }
                    },
                    color: Colors.blue,
                    child: widget.flagType == 'Edit' ?
                    new Text(
                        'Update', style: TextStyle(color: Colors.white))
                        : Text('Add', style: TextStyle(color: Colors.white)),
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