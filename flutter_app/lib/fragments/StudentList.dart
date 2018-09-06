import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/DataClass/Student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/UpdateStudentListProfile.dart';

class StudentList extends StatefulWidget {

  StudentList({Key key}) :super(key: key);

  @override
  StudentListState createState() => StudentListState();
}

class StudentListState extends State<StudentList> {

  Student _studData;
  List<StdArray> _listStudent = [];
  String _sessionUserId;

  @override
  void initState() {
    super.initState();
    _getSessionData();
  }

  _getSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionUserId = prefs.getString('user_id');
    });
    loadNewsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future loadNewsData() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws-getStudentByTeacher', body: {
        'school_id': '',
        'teacher_id': _sessionUserId,
        'get_teacher': ''
      });
      if (response.statusCode == 200) {
        _studData = new Student.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        return {"error": "Bad request"};
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      }

      if (_studData != null) {
        setState(() {
          _listStudent = _studData.studArray as List;
        });
      }
    } catch (err) {
      err.toString();
    }
  }

  void _selectedListItem(int index) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            UpdateStudentListProfile(
                stdUserId: _listStudent[index].stdUserId)));
  }

  @override
  Widget build(BuildContext context) {
    if (_studData == null) {
      return new Center(
        child: new Text(
          'No record available.', style: TextStyle(color: Colors.blue),
          textScaleFactor: 1.2,),
      );
    } else {
      return ListView.builder(
          itemCount: _listStudent.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _listStudent[index];
            return GestureDetector(
              onTap: () {
                _selectedListItem(index);
              },

              child: new Card(
                color: Colors.lightGreen,
                margin: EdgeInsets.all(10.0),
                elevation: 3.0,
                child: new Container(
                  padding: new EdgeInsets.all(5.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(width: 5.0),
                      new Expanded(
                        child: new CircleAvatar(
                            child: item.stdProfilePic != null &&
                                !item.stdProfilePic.isEmpty ?
                            new Image.network(
                                "http://182.72.79.154/p1136/media/front/img/user-profile-pictures/" +
                                    item.stdProfilePic) : Image.asset(
                                'assets/ic_launcher_launch.png')
                        ),
                        flex: 0,
                      ),

                      new Container(width: 20.0),
                      new Expanded(
                        child: new Column (
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text(item.stdFirstName, maxLines: 1,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.4,
                              style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),

                      new Container(width: 10.0,),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Container(
                              width: 10.0,
                            ),
                            new IconButton(
                                icon: new Icon(Icons.delete), onPressed: () {
                              Scaffold.of(context).showSnackBar(
                                  new SnackBar(content: new Text("Click")));
                            }),
                          ],
                        ),
                        flex: 0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      );
    }
  }
}