class ClassListData {
  List<ClassArray> list;

  ClassListData({
    this.list
  });

  factory ClassListData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'] as List;
    List<ClassArray> array = response.map((i) => ClassArray.fromJson(i))
        .toList();

    return ClassListData(
        list: array
    );
  }
}

class ClassArray {
  String classId;
  String classTitle;

  ClassArray({
    this.classId,
    this.classTitle
  });

  factory ClassArray.fromJson(Map<String, dynamic> parseJson){
    return ClassArray(
        classId: parseJson['class_id'],
        classTitle: parseJson['class_title']
    );
  }
}