class StudentProfileData {
  String stdProfileUserId;
  String stdProfileUserEmail;
  String stdProfileUserFirstName;
  String stdProfileUserLastName;
  String stdProfileUserMiddleName;
  String stdProfileUserType;
  String stdUserProfilePic;
  String stdUserProfileGender;
  String stdUserProfileDOB;
  String stdUserProfileAddressOne;
  String stdUserProfileAddressTwo;
  String stdUserProfileContactOne;
  String stdUserProfileContactTwo;
  String stdUserProfileParentName;
  String stdUserProfileClassId;
  String stdProfileUserSectionId;
  String stdProfileUserSubjectId;

  StudentProfileData({
    this.stdProfileUserId,
    this.stdProfileUserEmail,
    this.stdProfileUserFirstName,
    this.stdProfileUserLastName,
    this.stdProfileUserMiddleName,
    this.stdProfileUserType,
    this.stdUserProfileAddressOne,
    this.stdUserProfileAddressTwo,
    this.stdUserProfileContactOne,
    this.stdUserProfileContactTwo,
    this.stdUserProfileDOB,
    this.stdUserProfileGender,
    this.stdUserProfileParentName,
    this.stdUserProfilePic,
    this.stdProfileUserSectionId,
    this.stdProfileUserSubjectId,
    this.stdUserProfileClassId
  });

  factory StudentProfileData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'];
    var data = response['profileData'];
    return StudentProfileData(
        stdProfileUserId: data['user_id'],
        stdProfileUserEmail: data['user_email'],
        stdProfileUserFirstName: data['first_name'],
        stdProfileUserLastName: data['last_name'],
        stdProfileUserMiddleName: data['middle_name'],
        stdProfileUserType: data['user_type'],
        stdUserProfileAddressOne: data['address_first'],
        stdUserProfileAddressTwo: data['address_second'],
        stdUserProfileContactOne: data['contact_no_first'],
        stdUserProfileContactTwo: data['contact_no_second'],
        stdUserProfileDOB: data['user_birth_date'],
        stdUserProfileGender: data['gender'],
        stdUserProfileParentName: data['father_name'],
        stdUserProfilePic: data['profile_picture'],
        stdProfileUserSectionId: data['section_id'],
        stdProfileUserSubjectId: data['sub_id'],
        stdUserProfileClassId: data['class_id_fk']
    );
  }
}