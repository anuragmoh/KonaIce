import 'dart:convert';

ClockInOutPresenterRequestModel clockInOutPresenterRequestModelFromJson(String str) => ClockInOutPresenterRequestModel.fromJson(json.decode(str));

String clockInOutPresenterRequestModelToJson(ClockInOutPresenterRequestModel data) => json.encode(data.toJson());

class ClockInOutPresenterRequestModel {
  ClockInOutPresenterRequestModel({
    this.dutyStatus,
  });

  bool? dutyStatus;

  factory ClockInOutPresenterRequestModel.fromJson(Map<String, dynamic> json) => ClockInOutPresenterRequestModel(
    dutyStatus: json["dutyStatus"],
  );

  Map<String, dynamic> toJson() => {
    "dutyStatus": dutyStatus,
  };
}
