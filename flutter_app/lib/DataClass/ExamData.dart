class ExamData {
  List<ExamArray> list;

  ExamData({
    this.list
  });

  factory ExamData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'] as List;
    List<ExamArray> array = response.map((i) => ExamArray.fromJson(i)).toList();
    return ExamData(
        list: array
    );
  }
}

class ExamArray {
  String examId;
  String examTitle;

  ExamArray({
    this.examId,
    this.examTitle
  });

  factory ExamArray.fromJson(Map<String, dynamic> parseJson){
    return ExamArray(
        examId: parseJson['exam_id'],
        examTitle: parseJson['exam_title']
    );
  }
}