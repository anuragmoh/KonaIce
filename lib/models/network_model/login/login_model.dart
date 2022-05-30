import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  LoginRequestModel({
    this.email,
    this.password,
    this.deviceId,
    this.deviceType,
    this.deviceModel,
    this.os,
    this.osVersion,
    this.appVersion,
    this.deviceName,
  });

  String? email;
  String? password;
  String? deviceId;
  String? deviceType;
  String? deviceModel;
  String? os;
  String? osVersion;
  String? appVersion;
  String? deviceName;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        email: json["email"],
        password: json["password"],
        deviceId: json["deviceId"],
        deviceType: json["deviceType"],
        deviceModel: json["deviceModel"],
        os: json["os"],
        osVersion: json["osVersion"],
        appVersion: json["appVersion"],
        deviceName: json["deviceName"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "deviceId": deviceId,
        "deviceType": deviceType,
        "deviceModel": deviceModel,
        "os": os,
        "osVersion": osVersion,
        "appVersion": appVersion,
        "deviceName": deviceName,
      };
}

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel(
      {this.id,
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
      this.timezone,
      this.roles,
      // this.files,
      this.sessionKey,
      this.projectConfigs,
      this.merchantId,
      this.deviceId,
      this.finixSerialNumber,
      this.finixUsername,
      this.finixPassword,
      this.merchantIdNCP});

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
  String? timezone;
  List<Role>? roles;

  //Files? files;
  String? sessionKey;
  ProjectConfigs? projectConfigs;
  String? merchantId;
  String? deviceId;
  String? finixSerialNumber;
  String? finixUsername;
  String? finixPassword;
  String? merchantIdNCP;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
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
          timezone: json["timezone"],
          roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
          // files: Files.fromJson(json["files"]),
          sessionKey: json["sessionKey"],
          projectConfigs: ProjectConfigs.fromJson(json["projectConfigs"]),
          merchantId: json["merchantId"],
          deviceId: json["deviceId"],
          finixSerialNumber: json["finixSerialNumber"],
          finixUsername: json["finixUsername"],
          finixPassword: json["finixPassword"],
          merchantIdNCP: json["merchantIdNCP"]);

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
        "timezone": timezone,
        "roles": List<Role>.from(roles!.map((x) => x.toJson())),
        //"files": files?.toJson(),
        "sessionKey": sessionKey,
        "projectConfigs": projectConfigs!.toJson(),
        "merchantId": merchantId,
        "deviceId": deviceId,
        "finixSerialNumber": finixSerialNumber,
        "finixUsername": finixUsername,
        "finixPassword": finixPassword,
        "merchantIdNCP": merchantIdNCP
      };
}

class Files {
  Files({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.fileId,
    this.serverFileId,
    this.bucketId,
    this.sizeInBytes,
    this.mimeType,
    this.extension,
    this.originalFileName,
    this.thumbServerFileId,
    this.signUrl,
    this.thumbSignUrl,
    this.signUrlExpiry,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? fileId;
  String? serverFileId;
  String? bucketId;
  int? sizeInBytes;
  String? mimeType;
  String? extension;
  String? originalFileName;
  String? thumbServerFileId;
  String? signUrl;
  String? thumbSignUrl;
  int? signUrlExpiry;

  factory Files.fromJson(Map<String, dynamic> json) => Files(
        id: json["id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        deleted: json["deleted"],
        fileId: json["fileId"],
        serverFileId: json["serverFileId"],
        bucketId: json["bucketId"],
        sizeInBytes: json["sizeInBytes"],
        mimeType: json["mimeType"],
        extension: json["extension"],
        originalFileName: json["originalFileName"],
        thumbServerFileId: json["thumbServerFileId"],
        signUrl: json["signUrl"],
        thumbSignUrl: json["thumbSignUrl"],
        signUrlExpiry: json["signUrlExpiry"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "deleted": deleted,
        "fileId": fileId,
        "serverFileId": serverFileId,
        "bucketId": bucketId,
        "sizeInBytes": sizeInBytes,
        "mimeType": mimeType,
        "extension": extension,
        "originalFileName": originalFileName,
        "thumbServerFileId": thumbServerFileId,
        "signUrl": signUrl,
        "thumbSignUrl": thumbSignUrl,
        "signUrlExpiry": signUrlExpiry,
      };
}

class ProjectConfigs {
  ProjectConfigs({
    this.defaultTimezone,
    this.cronKey,
    this.resendOtpTimeInSec,
    this.foodExtraItemFileIds,
    this.defaultPaymentGateway,
    this.currencySymbol,
    this.frontendBaseUrl,
    this.eventDeliveryTime,
    this.eventLinkBaseUrl,
    this.currencySymbolHtmlCode,
    this.apiBaseUrl,
    this.menuFileIds,
  });

  String? defaultTimezone;
  String? cronKey;
  String? resendOtpTimeInSec;
  String? foodExtraItemFileIds;
  String? defaultPaymentGateway;
  String? currencySymbol;
  String? frontendBaseUrl;
  String? eventDeliveryTime;
  String? eventLinkBaseUrl;
  String? currencySymbolHtmlCode;
  String? apiBaseUrl;
  String? menuFileIds;

  factory ProjectConfigs.fromJson(Map<String, dynamic> json) => ProjectConfigs(
        defaultTimezone: json["default_timezone"],
        cronKey: json["cron_key"],
        resendOtpTimeInSec: json["resend_otp_time_in_sec"],
        foodExtraItemFileIds: json["food_extra_item_file_ids"],
        defaultPaymentGateway: json["default_payment_gateway"],
        currencySymbol: json["currency_symbol"],
        frontendBaseUrl: json["frontend_base_url"],
        eventDeliveryTime: json["event_delivery_time"],
        eventLinkBaseUrl: json["event_link_base_url"],
        currencySymbolHtmlCode: json["currency_symbol_html_code"],
        apiBaseUrl: json["api_base_url"],
        menuFileIds: json["menu_file_ids"],
      );

  Map<String, dynamic> toJson() => {
        "default_timezone": defaultTimezone,
        "cron_key": cronKey,
        "resend_otp_time_in_sec": resendOtpTimeInSec,
        "food_extra_item_file_ids": foodExtraItemFileIds,
        "default_payment_gateway": defaultPaymentGateway,
        "currency_symbol": currencySymbol,
        "frontend_base_url": frontendBaseUrl,
        "event_delivery_time": eventDeliveryTime,
        "event_link_base_url": eventLinkBaseUrl,
        "currency_symbol_html_code": currencySymbolHtmlCode,
        "api_base_url": apiBaseUrl,
        "menu_file_ids": menuFileIds,
      };
}

class Role {
  Role({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.roleName,
    this.roleCode,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? roleName;
  String? roleCode;

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
