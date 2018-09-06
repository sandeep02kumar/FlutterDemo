import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/DataClass/StudentDataByClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentListByClass extends StatefulWidget {
  final String classId;
  final String examId;

  const StudentListByClass({Key key, this.classId,
    this.examId}) :super(key: key);

  @override
  StudentListByClassState createState() => StudentListByClassState();
}

class StudentListByClassState extends State<StudentListByClass> {
  StudentDataByClass _studentDataByClass;
  List<StudentClassArray> listClassArray;
  String _userId;

  @override
  void initState() {
    super.initState();
    _getSessionData();
  }

  _getSessionData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = preferences.getString('user_id');
    });
    _loadExamListData();
  }

  Future _loadExamListData() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_getStudentListByClass', body: {
        'class_id': widget.classId,
        'user_id': _userId
      });
      if (response.statusCode == 200) {
        _studentDataByClass =
            StudentDataByClass.fromJson(json.decode(response.body));
      }
    } catch (err) {
      return err.toString();
    }
    if (_studentDataByClass != null) {
      setState(() {
        listClassArray = _studentDataByClass.list as List;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_studentDataByClass == null) {
      return new Center(
        child: new Text(
          'No record available.', style: TextStyle(color: Colors.blue),
          textScaleFactor: 1.2,),
      );
    } else {
      return Scaffold(
        appBar: new AppBar(
          title:
          new Text('Student List'),
        ),
        body: new ListView.builder(
          itemCount: listClassArray.length,
          itemBuilder: (BuildContext context, int index) {
            final item = listClassArray[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) =>
                        StudentListByClass(classId: widget.classId,
                          examId: listClassArray[index].scUserId,)));
              },
              child: new Card(
                color: Colors.lightGreen,
                margin: EdgeInsets.all(10.0),
                child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(width: 5.0),
                      new Expanded(
                          child: new Text(
                            item.scFirstName + ' ' + item.scLastName + ' ' +
                                '(' +
                                item.scSectionTitle + ')',
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.white),))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}