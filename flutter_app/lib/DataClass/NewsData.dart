//abstract class ListItem {}

class NewsData {
  String msg;
  List<NewsArray> arrayNews;

  NewsData({this.msg,
    this.arrayNews});

  factory NewsData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'];
    var listNews = response['arrayOfNewsDetails'] as List;

    List<NewsArray> arrayNewsData = listNews.map((i) => NewsArray.fromJson(i))
        .toList();
    return NewsData(
        msg: parseJson['msg'],
        arrayNews: arrayNewsData
    );
  }
}

class NewsArray {
  String newsTeacherId;
  String newsId;
  String newsTitle;
  String newsDesc;
  String newsDate;
  String newsUser;
  String newsImage;
  String newsFlag;
  String newsSchoolId;

  NewsArray({
    this.newsTeacherId,
    this.newsId,
    this.newsTitle,
    this.newsDesc,
    this.newsDate,
    this.newsUser,
    this.newsImage,
    this.newsFlag,
    this.newsSchoolId
  });

  factory NewsArray.fromJson(Map<String, dynamic> parseJson){
    return NewsArray(
        newsTeacherId: parseJson['teacher_id'],
        newsSchoolId: parseJson.containsKey('school_id')
            ? parseJson['school_id']
            : parseJson['atheltics_school'],
        newsId: parseJson.containsKey('news_id')
            ? parseJson['news_id']
            : parseJson['athilatic_id'],
        newsDate: parseJson['posted_on'],
        newsTitle: parseJson.containsKey('news_title')
            ? parseJson['news_title']
            : parseJson['atheltics_name'],
        newsDesc: parseJson.containsKey('news_description')
            ? parseJson['news_description']
            : parseJson['atheltics_description'],
        newsUser: parseJson.containsKey('posted_by')
            ? parseJson['posted_by']
            : parseJson['posted_date'],
        newsImage: parseJson.containsKey('news_image')
            ? parseJson['news_image']
            : parseJson['atheltics_image'],
        newsFlag: parseJson.containsKey('news_id') ? 'news' : 'athletic'
    );
  }
}

