class ClassData {
  List<ClassArray> listClass;

  ClassData({
    this.listClass
  });

  factory ClassData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'];
    var arrayList = response['arrayOfClass'] as List;

    List<ClassArray> arrayClass1 = arrayList.map((i) => ClassArray.fromJson(i))
        .toList();
    return ClassData(
        listClass: arrayClass1
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