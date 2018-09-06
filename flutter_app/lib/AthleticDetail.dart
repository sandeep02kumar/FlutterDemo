import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/DataClass/AthleticsData.dart';
import 'package:flutter_app/AddAndEditAthletic.dart';

class AthleticDetail extends StatefulWidget {

  final String athleticId;

  AthleticDetail({Key key, this.athleticId}) :super(key: key);

  @override
  AthleticDetailState createState() => AthleticDetailState();
}

class AthleticDetailState extends State<AthleticDetail> {

  AthleticsData arrayData;
  List<AthleticArray> mList = [];

  @override
  void initState() {
    super.initState();
    loadAthleticDetail();
  }

  Future loadAthleticDetail() async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_teache_athlatics_details', body: {
      'athilatic_id': widget.athleticId,
    });

    if (response.statusCode == 200) {
      arrayData = new AthleticsData.fromJson(json.decode(response.body));
    } else {

    }

    setState(() {
      mList = arrayData.athleticList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Athletic Detail'),
      ),
      body: new ListView.builder(
        itemCount: mList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = mList[index];
          return new Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: new Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  new CircleAvatar(
                    radius: 48.0,
                    backgroundColor: Colors.transparent,
                    child: item.athleticImage == null ||
                        item.athleticImage.isEmpty
                        ? new Image.asset('assets/ic_launcher_launch.png')
                        : Image.network(
                        'http://182.72.79.154/p1136/media/backend/img/news_image/' +
                            item.athleticImage),
                  ),

                  const SizedBox(height: 20.0),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '${item.athleticTitle}', textAlign: TextAlign.center,
                        textScaleFactor: 1.4,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Text("Description : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text(
                        "${item.athleticDesc}",
                        style: TextStyle(color: Colors.black54),),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("Date : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text(
                          "${item.athleticPostedOn}",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("Posted By : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text("${item.athleticPostedBy}",
                          style: TextStyle(color: Colors.black54)),
                    ],
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
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                AddAndEditAthletic(
                                  schoolId: item.athleticSchoolId,
                                  athleticId: item.athleticId,
                                  athleticTitle: item.athleticTitle,
                                  athleticDesc: item.athleticDesc,
                                  athleticTeacherId: item.athleticTeacherId,
                                  image:item.athleticImage,
                                  flagType: 'Edit')));
                      },
                      color: Colors.blue,
                      child: Text(
                        'EDIT', style: TextStyle(color: Colors.white),),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
