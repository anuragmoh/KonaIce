import 'dart:convert';

P2PDataModel p2PDataModelFromJson(String str) => P2PDataModel.fromJson(json.decode(str));

String p2PDataModelToJson(P2PDataModel data) => json.encode(data.toJson());

class P2PDataModel {
  P2PDataModel({
    required this.action,
    required this.data,
  });

  String action;
  String data;

  factory P2PDataModel.fromJson(Map<String, dynamic> json) => P2PDataModel(
    action: json["action"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "data": data,
  };
}
