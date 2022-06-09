import 'dart:convert';

class ClockInOutRequestModel {
  ClockInOutRequestModel({
    this.dutyStatus,
  });

  bool? dutyStatus;

  factory ClockInOutRequestModel.fromJson(Map<String, dynamic> json) =>
      ClockInOutRequestModel(
        dutyStatus: json["dutyStatus"],
      );

  Map<String, dynamic> toJson() => {
        "dutyStatus": dutyStatus,
      };
}

List<ClockInOutDetailsResponseModel> clockInOutDetailsResponseModelFromJson(
        String str) =>
    List<ClockInOutDetailsResponseModel>.from(json
        .decode(str)
        .map((x) => ClockInOutDetailsResponseModel.fromJson(x)));

class ClockInOutDetailsResponseModel {
  ClockInOutDetailsResponseModel({
    this.id,
    this.userId,
    this.clockInAt,
    this.clockOutAt,
    this.deleted,
    this.notes,
    this.firstName,
    this.lastName,
  });

  String? id;
  String? userId;
  int? clockInAt;
  int? clockOutAt;
  bool? deleted;
  dynamic notes;
  String? firstName;
  String? lastName;

  factory ClockInOutDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      ClockInOutDetailsResponseModel(
        id: json["id"],
        userId: json["userId"],
        clockInAt: json["clockInAt"],
        clockOutAt: json["clockOutAt"],
        deleted: json["deleted"],
        notes: json["notes"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "clockInAt": clockInAt,
        "clockOutAt": clockOutAt,
        "deleted": deleted,
        "notes": notes,
        "firstName": firstName,
        "lastName": lastName,
      };
}
