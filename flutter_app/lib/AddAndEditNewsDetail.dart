import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddAndEditNewsDetail extends StatefulWidget {
  final String newsId;
  final String newsImage;
  final String newsSchoolId;
  final String newsTitle;
  final String newsDesc;
  final String newsTeacherId;
  final String flagType;

  const AddAndEditNewsDetail({Key key,
    this.newsId,
    this.newsTitle,
    this.newsDesc,
    this.newsTeacherId,
    this.newsSchoolId,
    this.newsImage,
    this.flagType}) :super(key: key);

  @override
  AddAndEditNewsDetailState createState() => AddAndEditNewsDetailState();
}

class AddAndEditNewsDetailState extends State<AddAndEditNewsDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _sessionSchoolId;
  String _sessionUserId;
  String _sessionUserName;

  String _newsTitle = "";
  String _newsDesc = "";
  var _pickedImage;

  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _desController = new TextEditingController();

  @override
  void dispose() {
    _titleController.removeListener(_printLatestValue);
    _titleController.dispose();
    _desController.removeListener(_printLatestValue);
    _desController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getSessionData();
  }

  _getSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionUserId = prefs.getString('user_id');
      _sessionSchoolId = prefs.getString('school_id');
      _sessionUserName = prefs.getString('user_name');
    });

    _titleController.addListener(_printLatestValue);
    _desController.addListener(_printLatestValue);

    if (widget.flagType == 'Edit') {
      _titleController.text = widget.newsTitle;
      _desController.text = widget.newsDesc;
      _pickedImage = widget.newsImage;
    }
  }

  _printLatestValue() {
    _newsTitle = _titleController.text;
    _newsDesc = _desController.text;
  }

  Future openImagePicker() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = _image;
    });
  }

  Future _callWsAddNews() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_add_news', body: {
        'school_id': _sessionSchoolId,
        'teacher_id': _sessionUserName,
        'news_title': _newsTitle,
        'news_description': _newsDesc,
        'teacher_primary_key_id': _sessionUserId,
        'news_image': ''
      });

      if (response.statusCode == 200) {
        String msg = 'News added successfully.';
        _showInSnackBar(msg);
      } else {

      }
    } catch (err) {
      print(err.toString());
    }
  }


  Future _callWsEditNews() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_edit_news', body: {
        'news_id': widget.newsId,
        'school_id': _sessionSchoolId,
        'teacher_id': _sessionUserName,
        'news_title': _newsTitle,
        'news_description': _newsDesc,
        'teacher_primary_key_id': _sessionUserId,
        'news_image': ''
      });

      if (response.statusCode == 200) {
        String msg = 'News added successfully.';
        _showInSnackBar(msg);
      } else {

      }
    } catch (err) {
      print(err.toString());
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

  /*Future<bool> openDialogPickImage() async {
    return await showDialog(context: context,
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(title: new Text('Select'),),
            body: new ListView(
              children: [
                new Column(
                  children: <Widget>[
                    new DropdownButton<String>(
                        items: <String>['Camera', 'Gallery'].map((String value) {
                          return new DropdownMenuItem(
                              value: value,
                              child: new Text(value));
                        }).toList(),
                        onChanged: null)
                  ],
                ),
              ],
            ),
          );
        }
    ) ?? false;
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: widget.flagType == 'Edit' ?
        new Text('Edit News Detail', textAlign: TextAlign.center) :
        Text('Add News Detail', textAlign: TextAlign.center),
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
                    openImagePicker();
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Positioned(
                        child: new CircleAvatar(
                          radius: 48.0,
                          backgroundColor: Colors.transparent,
                          child: _pickedImage == null ? new
                          Image.asset('assets/ic_launcher_launch.png') : Image
                              .network(
                              'http://182.72.79.154/p1136/media/backend/img/news_image/' +
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

                const SizedBox(height: 40.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'News Title',
                    labelText: 'News Title',
                  ),
                  controller: _titleController,
                  maxLines: 1,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'News Description',
                    labelText: 'News Description',
                  ),
                  controller: _desController,
                  maxLines: 4,
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
                        _callWsEditNews();
                      } else {
                        _callWsAddNews();
                      }
                    },
                    color: Colors.blue,
                    child: widget.flagType == 'Edit' ?
                    new Text('Update', style: TextStyle(color: Colors.white)) :
                    Text('Add', style: TextStyle(color: Colors.white)),
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