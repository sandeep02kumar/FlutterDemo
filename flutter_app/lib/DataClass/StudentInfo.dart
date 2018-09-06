class StudentInfo {
  String stdUserId;
  String stdUserEmail;
  String stdUserPass;
  String stdFirstName;
  String stdLastName;
  String stdUserName;
  String stdUserType;
  String stdUserProfile;
  String stdUserSchoolId;

  StudentInfo({
    this.stdUserId,
    this.stdUserEmail,
    this.stdUserPass,
    this.stdUserName,
    this.stdFirstName,
    this.stdLastName,
    this.stdUserProfile,
    this.stdUserSchoolId,
    this.stdUserType
  });

  factory StudentInfo.fromJson(Map<String, dynamic> parseJsonInfo){
    var response = parseJsonInfo['Response'];
    var userDetails = response['user_details'];

    return StudentInfo(
      stdUserEmail: userDetails['user_email'],
      stdUserPass: userDetails['user_password'],
      stdUserName: userDetails['user_name'],
      stdFirstName: userDetails['first_name'],
      stdLastName: userDetails['last_name'],
      stdUserProfile: userDetails['profile_picture'],
      stdUserSchoolId: userDetails['school_id'],
      stdUserType: userDetails['user_type'],
      stdUserId: userDetails['user_id'],
    );
  }
}