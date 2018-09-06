import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/AddAndEditNewsDetail.dart';
import 'package:flutter_app/DataClass/NewsData.dart';

class NewsDetails extends StatefulWidget {
  final String newsId;

  const NewsDetails({ Key key, this.newsId}) : super(key: key);

  @override
  NewsDetailsState createState() => NewsDetailsState();
}

class NewsDetailsState extends State<NewsDetails> {

  NewsData arrayData;
  List<NewsArray> mList = [];

  @override
  void initState() {
    super.initState();
    loadNewsDetail();
  }

  Future loadNewsDetail() async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_getNewsDetails', body: {
      'news_id': widget.newsId,
    });

    if (response.statusCode == 200) {
      arrayData = new NewsData.fromJson(json.decode(response.body));
    } else {

    }

    setState(() {
      mList = arrayData.arrayNews as List;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("News Detail"),
      ),
      body: new ListView.builder(
        itemCount: mList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = mList[index];
          return new Form(
            child: new SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: new Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  new CircleAvatar(
                    radius: 48.0,
                    backgroundColor: Colors.transparent,
                    child: item.newsImage == null || item.newsImage.isEmpty ?
                    new Image.asset('assets/ic_launcher_launch.png') :
                    Image.network(
                        'http://182.72.79.154/p1136/media/backend/img/news_image/' +
                            item.newsImage),
                  ),

                  const SizedBox(height: 20.0),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '${item.newsTitle}', textAlign: TextAlign.center,
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
                        "${item.newsDesc}",
                        style: TextStyle(color: Colors.black54),),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("Posted On : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text(
                          "${item.newsDate}",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Text("Posted By : ", textScaleFactor: 1.2),
                      const SizedBox(height: 10.0),
                      new Text("${item.newsUser}",
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
                                AddAndEditNewsDetail(
                                  newsId: item.newsId,
                                  newsTitle: item.newsTitle,
                                  newsDesc: item.newsDesc,
                                  newsSchoolId: item.newsSchoolId,
                                  newsImage: item.newsImage,
                                  newsTeacherId: item.newsTeacherId,
                                  flagType: 'Edit',
                                )));
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