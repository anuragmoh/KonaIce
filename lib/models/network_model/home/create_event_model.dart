import 'dart:convert';

CreateEventRequestModel createEventRequestModelFromJson(String str) => CreateEventRequestModel.fromJson(json.decode(str));

String createEventRequestModelToJson(CreateEventRequestModel data) => json.encode(data.toJson());

class CreateEventRequestModel {
  CreateEventRequestModel({
    this.name,
    this.startDateTime,
    this.endDateTime,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.addressLatitude,
    this.addressLongitude,
    this.eventAssetsList,
  });

  String? name;
  int? startDateTime;
  int? endDateTime;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  double? addressLatitude;
  double? addressLongitude;
  List<EventAssetsList>? eventAssetsList;

  factory CreateEventRequestModel.fromJson(Map<String, dynamic> json) => CreateEventRequestModel(
    name: json["name"],
    startDateTime: json["startDateTime"],
    endDateTime: json["endDateTime"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipCode: json["zipCode"],
    addressLatitude: json["addressLatitude"].toDouble(),
    addressLongitude: json["addressLongitude"].toDouble(),
    eventAssetsList: List<EventAssetsList>.from(json["eventAssetsList"].map((x) => EventAssetsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "startDateTime": startDateTime,
    "endDateTime": endDateTime,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
    "addressLatitude": addressLatitude,
    "addressLongitude": addressLongitude,
    "eventAssetsList": List<dynamic>.from(eventAssetsList!.map((x) => x.toJson())),
  };
}

class EventAssetsList {
  EventAssetsList({
    this.assetId,
  });

  String? assetId;

  factory EventAssetsList.fromJson(Map<String, dynamic> json) => EventAssetsList(
    assetId: json["assetId"],
  );

  Map<String, dynamic> toJson() => {
    "assetId": assetId,
  };
}



CreateEventResponseModel createEventResponseModelFromJson(String str) => CreateEventResponseModel.fromJson(json.decode(str));

String createEventResponseModelToJson(CreateEventResponseModel data) => json.encode(data.toJson());

class CreateEventResponseModel {
  CreateEventResponseModel({
    this.general,
  });

  List<General>? general;

  factory CreateEventResponseModel.fromJson(Map<String, dynamic> json) => CreateEventResponseModel(
    general: List<General>.from(json["general"].map((x) => General.fromJson(x))),
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
