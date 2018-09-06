import 'dart:async';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/DataClass/ClassListData.dart';
import 'package:flutter_app/ExamList.dart';

class FragmentClassList extends StatefulWidget {

  const FragmentClassList({Key key}) :super(key: key);

  @override
  FragmentClassListState createState() => FragmentClassListState();
}

class FragmentClassListState extends State<FragmentClassList> {
  ClassListData _classListData;
  List<ClassArray> _listClass;
  String _sessionUserId;

  @override void initState() {
    super.initState();
    _getSessionData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getSessionData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _sessionUserId = preferences.getString('user_id');
    });
    _loadClassList();
  }

  Future _loadClassList() async {
    try {
      http.Response response = await http.post(
          "http://182.72.79.154/p1136/ws_get_teacher_class_list", body: {
        'teacher_id': _sessionUserId
      });
      if (response.statusCode == 200) {
        _classListData = ClassListData.fromJson(json.decode(response.body));
      }
    } catch (err) {
      return err.toString();
    }

    if (_classListData != null) {
      setState(() {
        _listClass = _classListData.list as List;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_classListData == null) {
      return new Center(
        child: new Text(
          'No record available.', style: TextStyle(color: Colors.blue),
          textScaleFactor: 1.2,),
      );
    } else {
      return ListView.builder(
        itemCount: _listClass.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _listClass[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ExamList(classId: _listClass[index].classId,)));
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
                        child: new Text(item.classTitle, maxLines: 1,
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.4,
                          style: TextStyle(color: Colors.white),))
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}