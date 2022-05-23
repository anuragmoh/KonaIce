// To parse this JSON data, do
//
//     final assetsModelResponse = assetsModelResponseFromJson(jsonString);

import 'dart:convert';

AssetsResponseModel assetsModelResponseFromJson(String str) =>
    AssetsResponseModel.fromJson(json.decode(str));

String assetsModelResponseToJson(AssetsResponseModel data) =>
    json.encode(data.toJson());

class AssetsResponseModel {
  AssetsResponseModel({
    this.count,
    this.limit,
    this.offset,
    this.sortColumn,
    this.sortType,
    this.searchText,
    this.data,
    this.fromDate,
    this.toDate,
  });

  int? count;
  int? limit;
  int? offset;
  dynamic sortColumn;
  dynamic sortType;
  dynamic searchText;
  List<Datum>? data;
  int? fromDate;
  int? toDate;

  factory AssetsResponseModel.fromJson(Map<String, dynamic> json) =>
      AssetsResponseModel(
        count: json["count"],
        limit: json["limit"],
        offset: json["offset"],
        sortColumn: json["sortColumn"],
        sortType: json["sortType"],
        searchText: json["searchText"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        fromDate: json["fromDate"],
        toDate: json["toDate"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "limit": limit,
        "offset": offset,
        "sortColumn": sortColumn,
        "sortType": sortType,
        "searchText": searchText,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "fromDate": fromDate,
        "toDate": toDate,
      };
}

class Datum {
  Datum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.code,
    this.assetTypeId,
    this.assetName,
    this.make,
    this.model,
    this.colorPicker,
    this.regNumber,
    this.franchiseId,
    this.imageFileId,
    this.activated,
    this.signUrl,
    this.sequence,
    this.gift,
    this.assetType,
    this.signUrlExpiry,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  AtedBy? createdBy;
  AtedBy? updatedBy;
  bool? deleted;
  String? code;
  String? assetTypeId;
  String? assetName;
  String? make;
  String? model;
  String? colorPicker;
  String? regNumber;
  FranchiseId? franchiseId;
  ImageFileId? imageFileId;
  bool? activated;
  String? signUrl;
  int? sequence;
  bool? gift;
  String? assetType;
  int? signUrlExpiry;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        createdBy: atedByValues.map![json["createdBy"]],
        updatedBy: atedByValues.map![json["updatedBy"]],
        deleted: json["deleted"],
        code: json["code"],
        assetTypeId: json["assetTypeId"],
        assetName: json["assetName"],
        make: json["make"],
        model: json["model"],
        colorPicker: json["colorPicker"],
        regNumber: json["regNumber"],
        franchiseId: franchiseIdValues.map![json["franchiseId"]],
        imageFileId: imageFileIdValues.map![json["imageFileId"]],
        activated: json["activated"],
        signUrl: json["signUrl"] == null ? null : json["signUrl"],
        sequence: json["sequence"],
        gift: json["gift"],
        assetType: json["assetType"] == null ? null : json["assetType"],
        signUrlExpiry: json["signUrlExpiry"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "createdBy": atedByValues.reverse![createdBy],
        "updatedBy": atedByValues.reverse![updatedBy],
        "deleted": deleted,
        "code": code,
        "assetTypeId": assetTypeId,
        "assetName": assetName,
        "make": make,
        "model": model,
        "colorPicker": colorPicker,
        "regNumber": regNumber,
        "franchiseId": franchiseIdValues.reverse![franchiseId],
        "imageFileId": imageFileIdValues.reverse![imageFileId],
        "activated": activated,
        "signUrl": signUrl == null ? null : signUrl,
        "sequence": sequence,
        "gift": gift,
        "assetType": assetType == null ? null : assetType,
        "signUrlExpiry": signUrlExpiry,
      };
}

enum AtedBy { THE_0830_E2157_FCF45849_B5_F51_CD4_B0_ECEBD }

final atedByValues = EnumValues({
  "0830e2157fcf45849b5f51cd4b0ecebd":
      AtedBy.THE_0830_E2157_FCF45849_B5_F51_CD4_B0_ECEBD
});

enum FranchiseId { THE_2_DA4_CA9843_AE491994_CAC47_D28_D0_AA8_D }

final franchiseIdValues = EnumValues({
  "2da4ca9843ae491994cac47d28d0aa8d":
      FranchiseId.THE_2_DA4_CA9843_AE491994_CAC47_D28_D0_AA8_D
});

enum ImageFileId {
  EMPTY,
  THE_63_F496_E99_A7_B4726_B40_F9_E7_ABE8_DB5_D7,
  THE_680529_C11_F924_CDDB16_EF0_C1_BCC882_FE
}

final imageFileIdValues = EnumValues({
  "": ImageFileId.EMPTY,
  "63f496e99a7b4726b40f9e7abe8db5d7":
      ImageFileId.THE_63_F496_E99_A7_B4726_B40_F9_E7_ABE8_DB5_D7,
  "680529c11f924cddb16ef0c1bcc882fe":
      ImageFileId.THE_680529_C11_F924_CDDB16_EF0_C1_BCC882_FE
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
