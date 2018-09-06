class SubjectData {
  List<arraySubject> listSubject;

  SubjectData({
    this.listSubject
  });

  factory SubjectData.fromJson(Map<String, dynamic> parseJson){
    var arrayList = parseJson['arrayOfSubject'] as List;

    List<arraySubject> _arraySubject = arrayList.map((i) =>
        arraySubject.fromJson(i))
        .toList();

    return SubjectData(
        listSubject: _arraySubject
    );
  }
}

class arraySubject {
  String subjectId;
  String subjectTitle;
  bool isCheck;

  arraySubject({
    this.subjectId,
    this.subjectTitle,
    this.isCheck
  });

  factory arraySubject.fromJson(Map<String, dynamic> parseJson){
    return arraySubject(
        subjectId: parseJson['sub_id'],
        subjectTitle: parseJson['sub_title'],
        isCheck: false
    );
  }
}