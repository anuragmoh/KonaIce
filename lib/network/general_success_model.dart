// To parse this JSON data, do
//
//     final generalSuccessModel = generalSuccessModelFromJson(jsonString);

import 'dart:convert';

GeneralSuccessModel generalSuccessModelFromJson(String str) =>
    GeneralSuccessModel.fromJson(json.decode(str));

String generalSuccessModelToJson(GeneralSuccessModel data) =>
    json.encode(data.toJson());

class GeneralSuccessModel {
  GeneralSuccessModel({
    this.general,
  });

  List<General>? general;

  factory GeneralSuccessModel.fromJson(Map<String, dynamic> json) =>
      GeneralSuccessModel(
        general:
            List<General>.from(json["general"].map((x) => General.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "general": List<dynamic>.from(general!.map((x) => x.toJson())),
      };
}

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
