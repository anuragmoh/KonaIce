import 'dart:convert';

ClockInOutRequestModel clockInOutRequestModelFromJson(String str) => ClockInOutRequestModel.fromJson(json.decode(str));

String clockInOutRequestModelToJson(ClockInOutRequestModel data) => json.encode(data.toJson());

class ClockInOutRequestModel {
  ClockInOutRequestModel({
    this.dutyStatus,
  });

  bool? dutyStatus;

  factory ClockInOutRequestModel.fromJson(Map<String, dynamic> json) => ClockInOutRequestModel(
    dutyStatus: json["dutyStatus"],
  );

  Map<String, dynamic> toJson() => {
    "dutyStatus": dutyStatus,
  };
}
