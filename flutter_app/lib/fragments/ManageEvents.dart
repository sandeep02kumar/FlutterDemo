import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/DataClass/EventsData.dart';
import 'package:flutter_app/EventDetail.dart';
import 'package:flutter_app/AthleticDetail.dart';

class ManageEvents extends StatefulWidget {
  ManageEvents({Key key}) :super(key: key);

  @override
  ManageEventsState createState() => ManageEventsState();
}

class ManageEventsState extends State<ManageEvents> {
  EventsData _eventsData;
  List<EventsArray> _eventArray = [];

  @override
  void initState() {
    super.initState();
    loadEventData();
  }

  Future loadEventData() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_getEventList',
          body: {
            'school_id': '289'
          });

      if (response.statusCode == 200) {
        _eventsData = new EventsData.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        return {"error": "Bad request"};
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      }

      if (_eventsData != null) {
        setState(() {
          _eventArray = _eventsData.listEvents;
        });
      }
    } on Exception {
      return {"error": "Some exception"};
    }
  }


  _onSelectedItem(int index) {
    if (_eventArray[index].eventFlag == 'event') {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) =>
              EventDetail(eventId: _eventArray[index].eventId)),
      );
    } else {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) =>
              AthleticDetail(athleticId: _eventArray[index].eventId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_eventsData == null) {
      return new Center(
        child: new Text(
          'Add some Events.', style: TextStyle(color: Colors.blue),
          textScaleFactor: 1.2,),
      );
    } else {
      return ListView.builder(
        itemCount: _eventArray.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _eventArray[index];
          return GestureDetector(
            onTap: () {
              _onSelectedItem(index);
            },

            child: Dismissible(
              key: Key(item.eventId),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  _eventArray.removeAt(index);
                });
              },

              child: new Card(
                color: Colors.lightGreenAccent,
                margin: EdgeInsets.all(10.0),
                elevation: 3.0,
                child: new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(width: 5.0),
                      new Expanded(
                        child: new CircleAvatar(
                            child: new Image.network(
                                "http://182.72.79.154/p1136/media/backend/img/event_image/" +
                                    item.eventImage)),
                        flex: 0,
                      ),

                      new Container(width: 20.0),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text(
                                item.eventTitle,
                                maxLines: 1,
                                textScaleFactor: 1.4,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black)),

                            new SizedBox(height: 5.0),
                            new Text(item.eventDesc, maxLines: 3,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black54)),

                            new SizedBox(height: 5.0),
                            new Row(
                              children: <Widget>[
                                new Text(item.eventDate != null ?
                                "${item.eventDate}" : "${item.eventPostedOn}",
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black38),
                                ),

                                new Container(width: 10.0),
                                new Text(item.eventTime != null ?
                                "${item.eventTime}" : "", maxLines: 1,
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
                              // _deleteEvent();
                            }
                        ),
                        new Text(item.eventPostedBy,
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
                image: item.eventImage != null ?
                "http://182.72.79.154/p1136/media/backend/img/event_image/" +
                    item.eventImage + "?raw=true"
                    : '',
                title: "${item.eventTitle}",
                content: "${item.eventDesc}",
                date: item.eventDate != null ?
                "${item.eventDate}" : "${item.eventPostedOn}",
                time: item.eventTime != null ?
                "${item.eventTime}" : "",
                trailingIconTwo: new Icon(
                  Icons.delete, color: Colors.redAccent,),
                textName: "${item.eventPostedBy}",
              ),*/
            ),
          );
        },
      );
    }
  }
}

class CustomWidget extends StatelessWidget {
  String image;
  String title;
  String content;
  String date;
  String time;
  String textName;
  Icon trailingIconTwo;

  CustomWidget({
    @required this.image, @required this.title, @required this.content, @required this.date, @required this.time, @required this.textName, @required this.trailingIconTwo
  });

  _deleteEvent() {
    print('click');
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.lightGreenAccent,
      margin: EdgeInsets.all(10.0),
      elevation: 3.0,
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

                      new Container(width: 10.0),
                      new Text(time, maxLines: 1,
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
                    _deleteEvent();
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
}