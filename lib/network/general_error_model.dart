import 'dart:convert';

class GeneralErrorList {
  GeneralErrorList({
    this.general,
  });

  List<GeneralErrorResponse>? general;

  factory GeneralErrorList.fromRawJson(String str) => GeneralErrorList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeneralErrorList.fromJson(Map<String, dynamic> json) => GeneralErrorList(
    general: json["general"] == null ? null : List<GeneralErrorResponse>.from(json["general"].map((x) => GeneralErrorResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "general": general == null ? null : List<dynamic>.from(general!.map((x) => x.toJson())),
  };
}

class GeneralErrorResponse {
  GeneralErrorResponse({
    this.messageCode,
    this.message,
  });

  String? messageCode;
  String? message;

  factory GeneralErrorResponse.fromRawJson(String str) => GeneralErrorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeneralErrorResponse.fromJson(Map<String, dynamic> json) => GeneralErrorResponse(
    messageCode: json["messageCode"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "messageCode": messageCode,
    "message": message,
  };
}
