// To parse this JSON data, do
//
//     final myProfileResponseModel = myProfileResponseModelFromJson(jsonString);

import 'dart:convert';

MyProfileResponseModel myProfileResponseModelFromJson(String str) => MyProfileResponseModel.fromJson(json.decode(str));

String myProfileResponseModelToJson(MyProfileResponseModel data) => json.encode(data.toJson());

class MyProfileResponseModel {
  MyProfileResponseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deleted,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNum,
    required this.numCountryCode,
    required this.profileImageFileId,
    required this.franchiseId,
    required this.activated,
    required this.emailVerified,
    required this.phoneNumberVerified,
    // this.timezone,
    required this.roles,
    // required this.files,
    required this.code,
    required this.franchisePhoneNumber,
    required this.connectAccountLink,
    required this.franchiseName,
    required this.franchisePhoneNumCountryCode,
    required this.franchiseEmail,
    required this.defaultTimezone,
    required this.billingName,
    required this.billingAddress,
    // this.billingCountry,
    required this.billingState,
    required this.billingCity,
    required this.billingZipCode,
    // this.addressLine2,
    required this.addressLine1,
    required this.country,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  String id;
  int createdAt;
  int updatedAt;
  String createdBy;
  String updatedBy;
  bool deleted;
  String firstName;
  String lastName;
  String email;
  String phoneNum;
  String numCountryCode;
  String profileImageFileId;
  String franchiseId;
  bool activated;
  bool emailVerified;
  bool phoneNumberVerified;
  // dynamic timezone;
  List<Role> roles;
  // Files files;
  String code;
  String franchisePhoneNumber;
  String connectAccountLink;
  String franchiseName;
  String franchisePhoneNumCountryCode;
  String franchiseEmail;
  String defaultTimezone;
  String billingName;
  String billingAddress;
  dynamic billingCountry;
  String billingState;
  String billingCity;
  String billingZipCode;
  // dynamic addressLine2;
  String addressLine1;
  String country;
  String city;
  String state;
  String zipCode;

  factory MyProfileResponseModel.fromJson(Map<String, dynamic> json) => MyProfileResponseModel(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNum: json["phoneNum"],
    numCountryCode: json["numCountryCode"],
    profileImageFileId: json["profileImageFileId"],
    franchiseId: json["franchiseId"],
    activated: json["activated"],
    emailVerified: json["emailVerified"],
    phoneNumberVerified: json["phoneNumberVerified"],
    // timezone: json["timezone"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
    // files: Files.fromJson(json["files"]),
    code: json["code"],
    franchisePhoneNumber: json["franchisePhoneNumber"],
    connectAccountLink: json["connectAccountLink"],
    franchiseName: json["franchiseName"],
    franchisePhoneNumCountryCode: json["franchisePhoneNumCountryCode"],
    franchiseEmail: json["franchiseEmail"],
    defaultTimezone: json["defaultTimezone"],
    billingName: json["billingName"],
    billingAddress: json["billingAddress"],
    // billingCountry: json["billingCountry"],
    billingState: json["billingState"],
    billingCity: json["billingCity"],
    billingZipCode: json["billingZipCode"],
    // addressLine2: json["addressLine2"],
    addressLine1: json["addressLine1"],
    country: json["country"],
    city: json["city"],
    state: json["state"],
    zipCode: json["zipCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNum": phoneNum,
    "numCountryCode": numCountryCode,
    "profileImageFileId": profileImageFileId,
    "franchiseId": franchiseId,
    "activated": activated,
    "emailVerified": emailVerified,
    "phoneNumberVerified": phoneNumberVerified,
    // "timezone": timezone,
    "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
    // "files": files.toJson(),
    "code": code,
    "franchisePhoneNumber": franchisePhoneNumber,
    "connectAccountLink": connectAccountLink,
    "franchiseName": franchiseName,
    "franchisePhoneNumCountryCode": franchisePhoneNumCountryCode,
    "franchiseEmail": franchiseEmail,
    "defaultTimezone": defaultTimezone,
    "billingName": billingName,
    "billingAddress": billingAddress,
    "billingCountry": billingCountry,
    "billingState": billingState,
    "billingCity": billingCity,
    "billingZipCode": billingZipCode,
    // "addressLine2": addressLine2,
    "addressLine1": addressLine1,
    "country": country,
    "city": city,
    "state": state,
    "zipCode": zipCode,
  };
}

class Files {
  Files({
    this.bucketId,
    required this.createdAt,
    required this.extension,
    required this.fileId,
    required this.id,
    this.mimeType,
    required this.originalFileName,
    required this.serverFileId,
    required this.signUrl,
    required this.signUrlExpiry,
    required this.sizeInBytes,
    required this.thumbServerFileId,
    required this.thumbSignUrl,
    required this.updatedAt,
  });

  dynamic bucketId;
  int createdAt;
  String extension;
  String fileId;
  String id;
  dynamic mimeType;
  String originalFileName;
  String serverFileId;
  String signUrl;
  int signUrlExpiry;
  int sizeInBytes;
  String thumbServerFileId;
  String thumbSignUrl;
  int updatedAt;

  factory Files.fromJson(Map<String, dynamic> json) => Files(
    bucketId: json["bucketId"],
    createdAt: json["createdAt"],
    extension: json["extension"],
    fileId: json["fileId"],
    id: json["id"],
    mimeType: json["mimeType"],
    originalFileName: json["originalFileName"],
    serverFileId: json["serverFileId"],
    signUrl: json["signUrl"],
    signUrlExpiry: json["signUrlExpiry"],
    sizeInBytes: json["sizeInBytes"],
    thumbServerFileId: json["thumbServerFileId"],
    thumbSignUrl: json["thumbSignUrl"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "bucketId": bucketId,
    "createdAt": createdAt,
    "extension": extension,
    "fileId": fileId,
    "id": id,
    "mimeType": mimeType,
    "originalFileName": originalFileName,
    "serverFileId": serverFileId,
    "signUrl": signUrl,
    "signUrlExpiry": signUrlExpiry,
    "sizeInBytes": sizeInBytes,
    "thumbServerFileId": thumbServerFileId,
    "thumbSignUrl": thumbSignUrl,
    "updatedAt": updatedAt,
  };
}

class Role {
  Role({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deleted,
    required this.roleName,
    required this.roleCode,
  });

  String id;
  int createdAt;
  int updatedAt;
  String createdBy;
  String updatedBy;
  bool deleted;
  String roleName;
  String roleCode;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
    roleName: json["roleName"],
    roleCode: json["roleCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
    "roleName": roleName,
    "roleCode": roleCode,
  };
}
