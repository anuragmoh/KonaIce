import 'dart:convert';

ForgotPasswordRequestModel forgotPasswordRequestModelFromJson(String str) => ForgotPasswordRequestModel.fromJson(json.decode(str));

String forgotPasswordRequestModelToJson(ForgotPasswordRequestModel data) => json.encode(data.toJson());

class ForgotPasswordRequestModel {
  ForgotPasswordRequestModel({
    this.email,
  });

  String? email;

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => ForgotPasswordRequestModel(
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}

ForgotPasswordResponseModel forgotPasswordResponseModelFromJson(String str) => ForgotPasswordResponseModel.fromJson(json.decode(str));

String forgotPasswordResponseModelToJson(ForgotPasswordResponseModel data) => json.encode(data.toJson());

class ForgotPasswordResponseModel {
  ForgotPasswordResponseModel({
    this.general,
  });

  List<General>? general;

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) => ForgotPasswordResponseModel(
    general: List<General>.from(json["general"].map((x) => General.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "general": List<dynamic>.from(general!.map((x) => x.toJson())),
  };
}

General generalResponseModelFromJson(String str) => General.fromJson(json.decode(str));


class General {
  General({
    this.messageCode,
    this.message,
  });

  String? messageCode;
  String? message;

  factory General.fromJson(Map<String, dynamic> json) => General(
    messageCode: json["messageCode"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "messageCode": messageCode,
    "message": message,
  };
}
