class MyProfileData {
  String profileUserId;
  String profileUserEmail;
  String profileUserPass;
  String profileFirstName;
  String profileLastName;
  String profileUserType;
  String profileUserProfile;
  String profileUserSchoolId;
  String profileUserGender;
  String profileUserBirthDate;
  String profileMiddleName;
  String profileAddressOne;
  String profileAddressTwo;
  String profileContactOne;
  String profileContactTwo;
  List<ClassArray> arrayOfClass;

  MyProfileData({
    this.profileUserId,
    this.profileUserEmail,
    this.profileUserPass,
    this.profileFirstName,
    this.profileLastName,
    this.profileUserProfile,
    this.profileUserSchoolId,
    this.profileUserType,
    this.profileAddressOne,
    this.profileAddressTwo,
    this.profileContactOne,
    this.profileContactTwo,
    this.profileMiddleName,
    this.profileUserBirthDate,
    this.profileUserGender,
    this.arrayOfClass
  });

  factory MyProfileData.fromJson(Map<String, dynamic> parseJsonInfo){
    var response = parseJsonInfo['Response'];
    var userDetails = response['profile_details'];

    var listClass = userDetails['arrayOfClass'] as List;
    List<ClassArray> listOfClass = listClass.map((i) => ClassArray.fromJson(i))
        .toList();

    return MyProfileData(
        profileUserEmail: userDetails['user_email'],
        profileUserPass: userDetails['user_password'],
        profileFirstName: userDetails['first_name'],
        profileLastName: userDetails['last_name'],
        profileUserProfile: userDetails['profile_picture'],
        profileUserSchoolId: userDetails['school_id'],
        profileUserType: userDetails['user_type'],
        profileUserId: userDetails['user_id'],
        profileAddressOne: userDetails['address_first'],
        profileAddressTwo: userDetails['address_second'],
        profileContactOne: userDetails['contact_no_first'],
        profileContactTwo: userDetails['contact_no_second'],
        profileMiddleName: userDetails['middle_name'],
        profileUserBirthDate: userDetails['user_birth_date'],
        profileUserGender: userDetails['gender'],
        arrayOfClass: listOfClass
    );
  }
}

class ClassArray {
  String classId;
  String classTitle;
  String classSectionTitle;

  ClassArray({
    this.classId,
    this.classSectionTitle,
    this.classTitle
  });

  factory ClassArray.fromJson(Map<String, dynamic> parseJson){
    return ClassArray(
        classId: parseJson['class_id'],
        classSectionTitle: parseJson['section_title'],
        classTitle: parseJson['class_title']
    );
  }
}