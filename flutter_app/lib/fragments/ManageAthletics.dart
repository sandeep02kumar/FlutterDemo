import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/DataClass/AthleticsData.dart';
import 'package:flutter_app/AthleticDetail.dart';

class ManageAthletics extends StatefulWidget {
  ManageAthletics({Key key}) :super(key: key);

  @override
  _ManageAthleticsState createState() => _ManageAthleticsState();
}

class _ManageAthleticsState extends State<ManageAthletics>
    with WidgetsBindingObserver {

  AthleticsData _athleticsData;
  List<AthleticArray> _listAthletic = [];

  @override
  void initState() {
    super.initState();
    _loadAthleticsData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("dispose");

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future _loadAthleticsData() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_getAthlaticsList', body: {
        'school_id': '289'
      });
      if (response.statusCode == 200) {
        _athleticsData = new AthleticsData.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        return {"error": "Bad request"};
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      }
    } catch (err) {
      return {"error": err};
    }

    if (_athleticsData != null) {
      setState(() {
        _listAthletic = _athleticsData.athleticList;
      });
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("did");
    setState(() {
      if (AppLifecycleState.resumed != null) {
        //loadAthleticsData();
        /* new Future.delayed(
            const Duration(seconds: 5), () => loadAthleticsData());*/
      }
    });
  }

  _onSelectedItem(int index) {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) =>
            AthleticDetail(athleticId: _listAthletic[index].athleticId)),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_athleticsData == null) {
      return new Center(
        child: new Text(
          'Add some Athletics.', style: TextStyle(color: Colors.blue),
          textScaleFactor: 1.2,),
      );
    } else {
      return ListView.builder(
        itemCount: _listAthletic.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _listAthletic[index];
          return GestureDetector(
            onTap: () {
              _onSelectedItem(index);
            },
            child: Dismissible(
              key: Key(item.athleticId),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  // _callWsDeleteNewsItem(index);
                  _listAthletic.removeAt(index);
                });
              },

              child: new Card(
                color: Colors.lightGreenAccent,
                margin: EdgeInsets.all(10.0),
                child: new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(width: 5.0),
                      new Expanded(
                        child: new CircleAvatar(
                            child: new Image.network(
                                "http://182.72.79.154/p1136/media/backend/img/news_image/" +
                                    item.athleticImage)),
                        flex: 0,
                      ),

                      new Container(width: 20.0),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text(
                                item.athleticTitle,
                                maxLines: 1,
                                textScaleFactor: 1.4,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black)),

                            new SizedBox(height: 5.0),
                            new Text(item.athleticDesc, maxLines: 3,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black54)),

                            new SizedBox(height: 5.0),
                            new Row(
                              children: <Widget>[
                                new Text(item.athleticPostedOn, maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      new Container(width: 10.0),
                      new Expanded(child: new Column(children: <Widget>[
                        new Container(width: 10.0,),
                        new IconButton(icon: new Icon(
                          Icons.delete, color: Colors.redAccent,),
                            onPressed: () {

                            }
                        ),
                        new Text(item.athleticPostedBy,
                          style: TextStyle(
                              color: Colors.green),),
                      ],),
                        flex: 0,
                      ),
                    ],
                  ),
                ),
              ),

              /*CustomWidget(
                image: item.athleticImage != null ?
                "http://182.72.79.154/p1136/media/backend/img/news_image/" +
                    item.athleticImage : '',
                title: "${item.athleticTitle}",
                content: "${item.athleticDesc}",
                date: "${item.athleticPostedOn}",
                trailingIconTwo: new Icon(
                  Icons.delete, color: Colors.redAccent,),
                textName: "${item.athleticPostedBy}",
              ),*/
            ),
          );
        },
      );
    }
  }
}

/*
class CustomWidget extends StatelessWidget {
  String image;
  String title;
  String content;
  String date;
  String textName;
  Icon trailingIconTwo;

  CustomWidget({
    @required this.image, @required this.title, @required this.content, @required this.date, @required this.textName, @required this.trailingIconTwo
  });

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.lightGreenAccent,
      margin: EdgeInsets.all(10.0),
      child: new Container(
        padding: EdgeInsets.all(5.0),
        child: new Row(
          children: <Widget>[
            new Container(width: 5.0),
            new Expanded(
              child: new CircleAvatar(
                  child: new Image.network(image)),
              flex: 0,
            ),

            new Container(width: 20.0),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Text(
                      title,
                      maxLines: 1,
                      textScaleFactor: 1.4,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black)),

                  new SizedBox(height: 5.0),
                  new Text(content, maxLines: 3,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black54)),

                  new SizedBox(height: 5.0),
                  new Row(
                    children: <Widget>[
                      new Text(date, maxLines: 1,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            new Container(width: 10.0),
            new Expanded(child: new Column(children: <Widget>[
              new Container(width: 10.0,),
              new IconButton(icon: trailingIconTwo,
                  onPressed: () {

                  }
              ),
              new Text(textName,
                style: TextStyle(
                    color: Colors.green),),
            ],),
              flex: 0,
            ),
          ],
        ),
      ),
    );
  }
}*/
