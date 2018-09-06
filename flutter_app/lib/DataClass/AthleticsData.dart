class AthleticsData {
  List<AthleticArray> athleticList;

  AthleticsData({this.athleticList});

  factory AthleticsData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'];
    var arrayAthl = response['arrayOfNewsDetails'] as List;

    List<AthleticArray> listArray = arrayAthl.map((i) =>
        AthleticArray.fromJson(i)).toList();
    return AthleticsData(
        athleticList: listArray
    );
  }
}

class AthleticArray {
  String athleticId;
  String athleticSchoolId;
  String athleticTeacherId;
  String athleticTitle;
  String athleticDesc;
  String athleticImage;
  String athleticPostedOn;
  String athleticPostedBy;

  AthleticArray({
    this.athleticId,
    this.athleticDesc,
    this.athleticImage,
    this.athleticPostedBy,
    this.athleticPostedOn,
    this.athleticSchoolId,
    this.athleticTeacherId,
    this.athleticTitle});

  factory AthleticArray.fromJson(Map<String, dynamic> parseJson){
    return AthleticArray(
        athleticId: parseJson['athilatic_id'],
        athleticDesc: parseJson['news_description'],
        athleticPostedBy: parseJson['posted_by'],
        athleticImage: parseJson['news_image'],
        athleticPostedOn: parseJson['posted_on'],
        athleticSchoolId: parseJson['school_id'],
        athleticTeacherId: parseJson['teacher_id'],
        athleticTitle: parseJson['news_title']
    );
  }
}