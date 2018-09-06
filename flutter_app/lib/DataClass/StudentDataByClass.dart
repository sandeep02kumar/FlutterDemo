class StudentDataByClass {
  List<StudentClassArray> list;

  StudentDataByClass({
    this.list
  });

  factory StudentDataByClass.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['arrayOfStudent'] as List;
    List<StudentClassArray> arrayList = response.map((i) =>
        StudentClassArray.fromJson(i)).toList();
    return StudentDataByClass(
        list: arrayList
    );
  }
}

class StudentClassArray {
  String scUserId;
  String scFirstName;
  String scLastName;
  String scSectionId;
  String scSectionTitle;

  StudentClassArray({
    this.scSectionId,
    this.scFirstName,
    this.scLastName,
    this.scSectionTitle,
    this.scUserId
  });

  factory StudentClassArray.fromJson(Map<String, dynamic> parseJson){
    return StudentClassArray(
        scUserId: parseJson['user_id'],
        scSectionId: parseJson['section_id_fk'],
        scFirstName: parseJson['first_name'],
        scLastName: parseJson['last_name'],
        scSectionTitle: parseJson['section_title']
    );
  }
}