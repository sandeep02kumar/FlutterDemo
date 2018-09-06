class Student {
  final List<StdArray> studArray;

  Student({
    this.studArray
  });

  factory Student.fromJson(Map<String, dynamic> parseJson){
    var res = parseJson['Response'];
    var list = res['studentArray'] as List;

    List<StdArray> imageList = list.map((i) => StdArray.fromJson(i)).toList();
    return Student(
        studArray: imageList
    );
  }
}

class StdArray {
  final String stdUserId;
  final String stdFirstName;
  final String stdLastName;
  final String stdProfilePic;
  final String stdUserType;

  StdArray({
    this.stdUserId,
    this.stdFirstName,
    this.stdLastName,
    this.stdUserType,
    this.stdProfilePic
  });

  factory StdArray.fromJson(Map<String, dynamic> parseJson){
    return StdArray(
        stdUserId: parseJson['user_id'],
        stdFirstName: parseJson['first_name'],
        stdLastName: parseJson['last_name'],
        stdUserType: parseJson['user_type'],
        stdProfilePic: parseJson['profile_picture']
    );
  }
}
