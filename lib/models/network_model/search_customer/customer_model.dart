import 'dart:convert';

import 'package:kona_ice_pos/common/extensions/string_extension.dart';

List<CustomerDetails> customerDetailsFromJson(String str) =>
    List<CustomerDetails>.from(
        json.decode(str).map((x) => CustomerDetails.fromJson(x)));

class CustomerDetails {
  CustomerDetails({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNum,
    this.numCountryCode,
    this.profileImageFileId,
    this.franchiseId,
    this.activated,
    this.emailVerified,
    this.phoneNumberVerified,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNum;
  String? numCountryCode;
  String? profileImageFileId;
  String? franchiseId;
  bool? activated;
  bool? emailVerified;
  bool? phoneNumberVerified;

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
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
      };

  String getFullName() {
    String customerName = StringExtension.empty();
    if (firstName != null) {
      customerName = (customerName + firstName! + ' ');
    }

    if (lastName != null) {
      customerName = (customerName + lastName!);
    }

    return customerName.toTitleCase();
  }
}
