import 'dart:convert';

PayOrderResponseModel payOrderResponseModelFromJson(String str) =>
    PayOrderResponseModel.fromJson(json.decode(str));

class PayOrderResponseModel {
  PayOrderResponseModel({
    this.status,
    this.messageKey,
  });

  String? status;
  String? messageKey;

  factory PayOrderResponseModel.fromJson(Map<String?, dynamic> json) =>
      PayOrderResponseModel(
        status: json["Status"],
        messageKey: json["messageKey"],
      );

  Map<String?, dynamic> toJson() => {
        "Status": status,
        "messageKey": messageKey,
      };
}
