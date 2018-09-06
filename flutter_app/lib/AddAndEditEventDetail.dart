import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAndEditEventDetail extends StatefulWidget {
  final String schoolId;
  final String teacherId;
  final String teacherKeyId;
  final String eventId;
  final String title;
  final String image;
  final String desc;
  final String date;
  final String time;
  final String url;
  final String flagType;

  AddAndEditEventDetail({Key key,
    this.schoolId,
    this.teacherId,
    this.teacherKeyId,
    this.eventId,
    this.title,
    this.image,
    this.desc,
    this.date,
    this.time,
    this.url,
    this.flagType,
  }) :super(key: key);

  @override
  AddAndEditEventDetailState createState() => AddAndEditEventDetailState();
}

class AddAndEditEventDetailState extends State<AddAndEditEventDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _sessionSchoolId;
  String _sessionUserId;
  String _sessionUserName;

  String _eventTitle = "";
  String _eventDesc = "";
  String _eventUrl = "";
  DateTime _eventDate;
  TimeOfDay _eventTime;
  var _pickedImage;

  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _desController = new TextEditingController();
  final TextEditingController _dateController = new TextEditingController();
  final TextEditingController _timeController = new TextEditingController();
  final TextEditingController _urlController = new TextEditingController();

  @override
  void dispose() {
    _titleController.removeListener(_printLatestValue);
    _titleController.dispose();
    _desController.removeListener(_printLatestValue);
    _desController.dispose();
    _dateController.removeListener(_printLatestValue);
    _dateController.dispose();
    _timeController.removeListener(_printLatestValue);
    _timeController.dispose();
    _urlController.removeListener(_printLatestValue);
    _urlController.dispose();

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
    _urlController.addListener(_printLatestValue);

    if (widget.flagType == 'Edit') {
      _titleController.text = widget.title;
      _desController.text = widget.desc;
      _urlController.text = widget.url;
      _dateController.text = widget.date;
      _timeController.text = widget.time;
      _pickedImage = widget.image;
    }
  }

  _printLatestValue() {
    _eventTitle = _titleController.text;
    _eventDesc = _desController.text;
    _eventUrl = _urlController.text;
  }

  Future _callWsAddEvent() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_add_event', body: {
        'school_id': _sessionSchoolId,
        'teacher_id': _sessionUserName,
        'event_time': '',
        'event_date': '',
        'event_title': _eventTitle,
        'event_description': _eventDesc,
        'event_url': _eventUrl,
        'teacher_primary_key_id': _sessionUserId,
        'event_image': ''
      });

      if (response.statusCode == 200) {
        String msg = 'Event added successfully.';
        _showInSnackBar(msg);
      } else {

      }
    } catch (err) {
      print(err.toString());
    }
  }


  Future _callWsEditEvent() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_teacher_edit_event', body: {
        'event_id': widget.eventId,
        'school_id': _sessionSchoolId,
        'teacher_id': _sessionUserName,
        'event_time': _timeController.text,
        'event_date': _dateController.text,
        'event_title': _eventTitle,
        'event_description': _eventDesc,
        'event_url': _eventUrl,
        'teacher_primary_key_id': _sessionUserId,
        'event_image': ''
      });

      if (response.statusCode == 200) {
        String msg = 'Event added successfully.';
        _showInSnackBar(msg);
      } else {

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

  Future<Null> _datePickerDialog() async {
    final DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2050));

    if (dateTime != null) {
      setState(() {
        _eventDate = dateTime;
        var strDate = dateTime.toString().substring(0, 10);
        _dateController.text = strDate;
      });
    }
  }

  Future<Null> _timePickerDialog() async {
    final TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());

    if (time != null) {
      setState(() {
        _eventTime = time;
        var strTime = time.toString().replaceAll('TimeOfDay(', '');
        var strTime1 = strTime.replaceAll(")", "");
        _timeController.text = strTime1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: widget.flagType == 'Edit' ?
        new Text('Edit Event Detail', textAlign: TextAlign.center,) :
        Text('Add Event Detail', textAlign: TextAlign.center),
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
                              : Image.network(
                              'http://182.72.79.154/p1136/media/backend/img/event_image/' +
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
                      hintText: 'Event Title',
                      labelText: 'Event Title'
                  ),
                  controller: _titleController,
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Event Description',
                      labelText: 'Event Description '
                  ),
                  controller: _desController,
                ),

                const SizedBox(height: 20.0),
                new Stack(
                  children: <Widget>[
                    new Positioned(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Event Date',
                            labelText: 'Event Date'
                        ),
                        controller: _dateController,
                      ),
                    ),
                    new Positioned(
                      right: 10.0,
                      top: 15.0,
                      child: new GestureDetector(
                        onTap: () {
                          _datePickerDialog();
                        },
                        child: new Icon(Icons.date_range),),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                new Stack(
                  children: <Widget>[
                    new Positioned(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Event Time',
                            labelText: 'Event Time'
                        ),
                        controller: _timeController,
                      ),
                    ),

                    new Positioned(
                      right: 10.0,
                      top: 15.0,
                      child: new GestureDetector(
                        onTap: () {
                          _timePickerDialog();
                        },
                        child: new Icon(Icons.timer),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Event Url',
                      labelText: 'Event Url'
                  ),
                  controller: _urlController,
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
                        _callWsEditEvent();
                      } else {
                        _callWsAddEvent();
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