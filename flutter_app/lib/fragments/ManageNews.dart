import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:flutter/material.dart';
import 'package:flutter_app/DataClass/NewsData.dart';
import 'package:flutter_app/NewsDetails.dart';
import 'package:flutter_app/AthleticDetail.dart';
import 'package:http/http.dart' as http;

class ManageNews extends StatefulWidget {
  ManageNews({Key key}) : super(key: key);

  @override
  ManageNewsState createState() => ManageNewsState();
}

class ManageNewsState extends State<ManageNews> {

  NewsData _newsData;
  List<NewsArray> _listNews = [];

  @override
  void initState() {
    super.initState();
    loadNewsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future loadNewsData() async {
    try {
      http.Response response = await http.post(
          'http://182.72.79.154/p1136/ws_getNewsList', body: {
        'school_id': '289',
      });
      if (response.statusCode == 200) {
        _newsData = new NewsData.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        return {"error": "Bad request"};
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      }

      if (_newsData != null) {
        setState(() {
          _listNews = _newsData.arrayNews;
        });
      }
    } catch (err) {
      err.toString();
    }
  }

  _onSelectedItem(int index) {
    if (_listNews[index].newsFlag == 'news') {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) =>
              NewsDetails(newsId: _listNews[index].newsId)),
      );
    } else {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) =>
              AthleticDetail(athleticId: _listNews[index].newsId)),
      );
    }
  }

  Future _callWsDeleteNewsItem(int index) async {
    http.Response response = await http.post(
        'http://182.72.79.154/p1136/ws_deleteNews', body: {
      'school_id': _listNews[index].newsSchoolId,
      'news_id': _listNews[index].newsId,
    });

    if (response.statusCode == 200) {
      response.body;
    } else if (response.statusCode == 400) {
      return {"error": "Bad request"};
    } else if (response.statusCode == 401) {
      return {"error": "Unauthorized"};
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (_newsData == null) {
      return new Center(
        child: new Text(
          'Add some News.', style: TextStyle(color: Colors.blue),
          textScaleFactor: 1.2,),
      );
    } else {
      return ListView.builder(
        itemCount: _listNews.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _listNews[index];
          return GestureDetector(
            onTap: () {
              _onSelectedItem(index);
            },

            child: Dismissible(
              key: Key(item.newsId),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  //   _callWsDeleteNewsItem(index);
                  _listNews.removeAt(index);
                });
              },

              child: new Card(
                color: Colors.lightGreenAccent,
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
                            child: new Image.network(
                                "http://182.72.79.154/p1136/media/backend/img/news_image/" +
                                    item.newsImage)),
                        flex: 0,
                      ),

                      new Container(width: 20.0),
                      new Expanded(
                        child: new Column (
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text(item.newsTitle, maxLines: 1,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.4,
                              style: TextStyle(color: Colors.black),),

                            new SizedBox(height: 5.0),
                            new Text(item.newsDesc, maxLines: 3,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black54),
                              softWrap: true,),

                            new SizedBox(height: 5.0),
                            new Text(item.newsDate, maxLines: 1,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black38),)
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
                                icon: new Icon(
                                  Icons.delete, color: Colors.redAccent,),
                                onPressed: () {
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(content: new Text("Click")));
                                }),
                            new Text(
                              item.newsUser,
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        flex: 0,
                      ),
                    ],
                  ),
                ),
              ),

              /*CustomWidget(
                image: item.newsImage != null ?
                "http://182.72.79.154/p1136/media/backend/img/news_image/" +
                    item.newsImage + "?raw=true"
                    : '',
                title: "${item.newsTitle}",
                content: "${item.newsDesc}",
                date: "${item.newsDate}",
                trailingIconTwo: new Icon(
                  Icons.delete, color: Colors.redAccent,),
                textName: "${item.newsUser}",
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
      elevation: 3.0,
      child: new Container(
        padding: new EdgeInsets.all(5.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(width: 5.0),
            new Expanded(
              child: new CircleAvatar(
                  child: new Image.network(image)),
              flex: 0,
            ),

            new Container(width: 20.0),
            new Expanded(
              child: new Column (
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Text(title, maxLines: 1,
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.4,
                    style: TextStyle(color: Colors.black),),

                  new SizedBox(height: 5.0),
                  new Text(content, maxLines: 3,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black54),
                    softWrap: true,),

                  new SizedBox(height: 5.0),
                  new Text(date, maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black38),)
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
                  new IconButton(icon: trailingIconTwo, onPressed: () {
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(content: new Text("Click")));
                  }),
                  new Text(
                    textName, style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              flex: 0,
            ),
          ],
        ),
      ),
    );
  }
}*/
