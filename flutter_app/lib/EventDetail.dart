import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/DataClass/EventsData.dart';
import 'package:flutter_app/AddAndEditEventDetail.dart';

class EventDetail extends StatefulWidget {

  final String eventId;

  EventDetail({Key key, this.eventId}) :super(key: key);

  @override
  EventDetailState createState() => EventDetailState();
}

class EventDetailState extends State<EventDetail> {

  EventsData arrayData;
  List<EventsArray> mList = [];

  @override
  void initState() {
    super.initState();
    loadNewsDetail();
  }

  Future loadNewsDetail() async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_getEventDetails', body: {
      'event_id': widget.eventId,
    });

    if (response.statusCode == 200) {
      arrayData = new EventsData.fromJson(json.decode(response.body));
    } else {

    }

    setState(() {
      mList = arrayData.listEvents;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Event Detail'),
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
                    child: item.eventImage == null || item.eventImage.isEmpty
                        ? new Image.asset('assets/ic_launcher_launch.png')
                        : Image.network(
                        'http://182.72.79.154/p1136/media/backend/img/event_image/' +
                            item.eventImage),
                  ),

                  const SizedBox(height: 20.0),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '${item.eventTitle}', textAlign: TextAlign.center,
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
                        "${item.eventDesc}",
                        style: TextStyle(color: Colors.black54),),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("Date : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text(
                          "${item.eventDate}",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("Time : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text(
                          "${item.eventTime}",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("Posted By : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text("${item.eventPostedBy}",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("URL : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text(
                          "${item.eventLink}",
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
                                AddAndEditEventDetail(
                                  schoolId: item.schoolId,
                                  teacherId: item.teacherId,
                                  teacherKeyId: item.teacherId,
                                  eventId: item.eventId,
                                  title: item.eventTitle,
                                  image: item.eventImage,
                                  desc: item.eventDesc,
                                  date: item.eventDate,
                                  time: item.eventTime,
                                  url: item.eventLink,
                                  flagType: 'Edit',)));
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
