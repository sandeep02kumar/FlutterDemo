import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/DataClass/ExamData.dart';
import 'package:flutter_app/StudentListByClass.dart';

class ExamList extends StatefulWidget {
  final String classId;

  const ExamList({Key key, this.classId}) :super(key: key);

  @override
  ExamListState createState() => ExamListState();
}

class ExamListState extends State<ExamList> {
  ExamData _examData;
  List<ExamArray> _listArray;

  @override
  void initState() {
    super.initState();
    _loadExamListData();
  }

  Future _loadExamListData() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_get_exam_list', body: {
        'class_id': widget.classId
      });
      if (response.statusCode == 200) {
        _examData = ExamData.fromJson(json.decode(response.body));
      }
    } catch (err) {
      return err.toString();
    }
    if (_examData != null) {
      setState(() {
        _listArray = _examData.list as List;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_examData == null) {
      return new Center(
        child: new Text(
          'No record available.', style: TextStyle(color: Colors.blue),
          textScaleFactor: 1.2,),
      );
    } else {
      return Scaffold(
        appBar: new AppBar(
          title:
          new Text('Exam List'),
        ),
        body: new ListView.builder(
          itemCount: _listArray.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _listArray[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) =>
                        StudentListByClass(classId: widget.classId,
                          examId: _listArray[index].examId,)));
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
                          child: new Text(item.examTitle, maxLines: 1,
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.white),))
                    ],
                  ),
                ),
              ),
            );
          }
          ,
        ),
      );
    }
  }
}