

class MyProfileUpdateRequestModel {
  MyProfileUpdateRequestModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNum,
    this.numCountryCode,
    this.password,
    this.franchiseName,
    this.franchiseEmail,
    this.franchisePhoneNumber,
    this.franchisePhoneNumCountryCode,
    this.profileImageFileId,
    this.defaultTimezone,
  });

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNum;
  String? numCountryCode;
  String? password;
  String? franchiseName;
  String? franchiseEmail;
  String? franchisePhoneNumber;
  String? franchisePhoneNumCountryCode;
  String? profileImageFileId;
  String? defaultTimezone;

  factory MyProfileUpdateRequestModel.fromJson(Map<String, dynamic> json) =>
      MyProfileUpdateRequestModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNum: json["phoneNum"],
        numCountryCode: json["numCountryCode"],
        password: json["password"],
        franchiseName: json["franchiseName"],
        franchiseEmail: json["franchiseEmail"],
        franchisePhoneNumber: json["franchisePhoneNumber"],
        franchisePhoneNumCountryCode: json["franchisePhoneNumCountryCode"],
        profileImageFileId: json["profileImageFileId"],
        defaultTimezone: json["defaultTimezone"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNum": phoneNum,
        "numCountryCode": numCountryCode,
        "password": password,
        "franchiseName": franchiseName,
        "franchiseEmail": franchiseEmail,
        "franchisePhoneNumber": franchisePhoneNumber,
        "franchisePhoneNumCountryCode": franchisePhoneNumCountryCode,
        "profileImageFileId": profileImageFileId,
        "defaultTimezone": defaultTimezone,
      };
}
