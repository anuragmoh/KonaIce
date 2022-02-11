
import 'dart:convert';

SyncEventMenu syncEventMenuFromJson(String str) => SyncEventMenu.fromJson(json.decode(str));

String syncEventMenuToJson(SyncEventMenu data) => json.encode(data.toJson());

class SyncEventMenu {
  SyncEventMenu({
    required this.pOsSyncEventDataDtoList,
    required this.pOsSyncItemCategoryDataDtoList,
    required this.pOsSyncEventItemDataDtoList,
    required this.pOsSyncEventItemExtrasDataDtoList,
    required this.pOsSyncDeletedEventDataDtoList,
    required this.pOsSyncDeletedItemCategoryDataDtoList,
    required this.pOsSyncDeletedEventItemDataDtoList,
    required this.pOsSyncDeletedEventItemExtrasDataDtoList,
  });

  List<POsSyncEventDataDtoList> pOsSyncEventDataDtoList;
  List<POsSyncItemCategoryDataDtoList> pOsSyncItemCategoryDataDtoList;
  List<POsSyncEventItemDataDtoList> pOsSyncEventItemDataDtoList;
  List<POsSyncEventItemExtrasDataDtoList> pOsSyncEventItemExtrasDataDtoList;
  List<POsSyncEventDataDtoList> pOsSyncDeletedEventDataDtoList;
  List<POsSyncItemCategoryDataDtoList> pOsSyncDeletedItemCategoryDataDtoList;
  List<POsSyncEventItemDataDtoList> pOsSyncDeletedEventItemDataDtoList;
  List<POsSyncEventItemExtrasDataDtoList> pOsSyncDeletedEventItemExtrasDataDtoList;

  factory SyncEventMenu.fromJson(Map<String, dynamic> json) => SyncEventMenu(
    pOsSyncEventDataDtoList: List<POsSyncEventDataDtoList>.from(json["pOSSyncEventDataDtoList"].map((x) => POsSyncEventDataDtoList.fromJson(x))),
    pOsSyncItemCategoryDataDtoList: List<POsSyncItemCategoryDataDtoList>.from(json["pOSSyncItemCategoryDataDtoList"].map((x) => POsSyncItemCategoryDataDtoList.fromJson(x))),
    pOsSyncEventItemDataDtoList: List<POsSyncEventItemDataDtoList>.from(json["pOSSyncEventItemDataDtoList"].map((x) => POsSyncEventItemDataDtoList.fromJson(x))),
    pOsSyncEventItemExtrasDataDtoList: List<POsSyncEventItemExtrasDataDtoList>.from(json["pOSSyncEventItemExtrasDataDtoList"].map((x) => POsSyncEventItemExtrasDataDtoList.fromJson(x))),
    pOsSyncDeletedEventDataDtoList: List<POsSyncEventDataDtoList>.from(json["pOSSyncDeletedEventDataDtoList"].map((x) => POsSyncEventDataDtoList.fromJson(x))),
    pOsSyncDeletedItemCategoryDataDtoList: List<POsSyncItemCategoryDataDtoList>.from(json["pOSSyncDeletedItemCategoryDataDtoList"].map((x) => POsSyncItemCategoryDataDtoList.fromJson(x))),
    pOsSyncDeletedEventItemDataDtoList: List<POsSyncEventItemDataDtoList>.from(json["pOSSyncDeletedEventItemDataDtoList"].map((x) => POsSyncEventItemDataDtoList.fromJson(x))),
    pOsSyncDeletedEventItemExtrasDataDtoList: List<POsSyncEventItemExtrasDataDtoList>.from(json["pOSSyncDeletedEventItemExtrasDataDtoList"].map((x) => POsSyncEventItemExtrasDataDtoList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pOSSyncEventDataDtoList": List<dynamic>.from(pOsSyncEventDataDtoList.map((x) => x.toJson())),
    "pOSSyncItemCategoryDataDtoList": List<dynamic>.from(pOsSyncItemCategoryDataDtoList.map((x) => x.toJson())),
    "pOSSyncEventItemDataDtoList": List<dynamic>.from(pOsSyncEventItemDataDtoList.map((x) => x.toJson())),
    "pOSSyncEventItemExtrasDataDtoList": List<dynamic>.from(pOsSyncEventItemExtrasDataDtoList.map((x) => x.toJson())),
    "pOSSyncDeletedEventDataDtoList": List<dynamic>.from(pOsSyncDeletedEventDataDtoList.map((x) => x.toJson())),
    "pOSSyncDeletedItemCategoryDataDtoList": List<dynamic>.from(pOsSyncDeletedItemCategoryDataDtoList.map((x) => x.toJson())),
    "pOSSyncDeletedEventItemDataDtoList": List<dynamic>.from(pOsSyncDeletedEventItemDataDtoList.map((x) => x.toJson())),
    "pOSSyncDeletedEventItemExtrasDataDtoList": List<dynamic>.from(pOsSyncDeletedEventItemExtrasDataDtoList.map((x) => x.toJson())),
  };
}

class POsSyncEventDataDtoList {
  POsSyncEventDataDtoList({
    required this.eventId,
    required  this.eventCode,
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.startDateTime,
    required this.endDateTime,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required  this.updatedBy,
    required this.deleted,
  });

  String? eventId;
  String? eventCode;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  int? startDateTime;
  int? endDateTime;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;

  factory POsSyncEventDataDtoList.fromJson(Map<String, dynamic> json) => POsSyncEventDataDtoList(
    eventId: json["eventId"],
    eventCode: json["eventCode"],
    name: json["name"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipCode: json["zipCode"],
    startDateTime: json["startDateTime"],
    endDateTime: json["endDateTime"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "eventId": eventId,
    "eventCode": eventCode,
    "name": name,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
    "startDateTime": startDateTime,
    "endDateTime": endDateTime,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
  };
}

class POsSyncEventItemDataDtoList {
  POsSyncEventItemDataDtoList({
     this.itemCategoryId,
     this.eventId,
     this.itemId,
     this.itemCode,
     this.name,
     this.description,
     this.price,
     this.soldQty,
     this.compQty,
     this.createdAt,
     this.updatedAt,
     this.createdBy,
     this.updatedBy,
     this.deleted,
  });

  String? itemCategoryId;
  String? eventId;
  String? itemId;
  String? itemCode;
  String? name;
  String? description;
  double? price;
  int? soldQty;
  int? compQty;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;

  factory POsSyncEventItemDataDtoList.fromJson(Map<String, dynamic> json) => POsSyncEventItemDataDtoList(
    itemCategoryId: json["itemCategoryId"],
    eventId: json["eventId"],
    itemId: json["itemId"],
    itemCode: json["itemCode"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    soldQty: json["soldQty"],
    compQty: json["compQty"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "itemCategoryId": itemCategoryId,
    "eventId": eventId,
    "itemId": itemId,
    "itemCode": itemCode,
    "name": name,
    "description": description,
    "price": price,
    "soldQty": soldQty,
    "compQty": compQty,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
  };
}

class POsSyncEventItemExtrasDataDtoList {
  POsSyncEventItemExtrasDataDtoList({
     this.eventId,
     this.itemId,
     this.foodExtraItemId,
     this.itemName,
     this.sellingPrice,
     this.imageFileId,
     this.minQtyAllowed,
     this.maxQtyAllowed,
     this.createdAt,
     this.updatedAt,
     this.createdBy,
     this.updatedBy,
     this.deleted,
  });

  String? eventId;
  String? itemId;
  String? foodExtraItemId;
  String? itemName;
  double? sellingPrice;
  String? imageFileId;
  int? minQtyAllowed;
  int? maxQtyAllowed;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;

  factory POsSyncEventItemExtrasDataDtoList.fromJson(Map<String, dynamic> json) => POsSyncEventItemExtrasDataDtoList(
    eventId: json["eventId"],
    itemId: json["itemId"],
    foodExtraItemId: json["foodExtraItemId"],
    itemName: json["itemName"],
    sellingPrice: json["sellingPrice"],
    imageFileId: json["imageFileId"],
    minQtyAllowed: json["minQtyAllowed"],
    maxQtyAllowed: json["maxQtyAllowed"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "eventId": eventId,
    "itemId": itemId,
    "foodExtraItemId": foodExtraItemId,
    "itemName": itemName,
    "sellingPrice": sellingPrice,
    "imageFileId": imageFileId,
    "minQtyAllowed": minQtyAllowed,
    "maxQtyAllowed": maxQtyAllowed,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
  };
}

class POsSyncItemCategoryDataDtoList {
  POsSyncItemCategoryDataDtoList({
     this.eventId,
     this.categoryId,
    this.categoryCode,
     this.categoryName,
     this.createdAt,
     this.updatedAt,
     this.createdBy,
     this.updatedBy,
     this.deleted,
  });

  String? eventId;
  String? categoryId;
  String? categoryCode;
  String? categoryName;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;

  factory POsSyncItemCategoryDataDtoList.fromJson(Map<String, dynamic> json) => POsSyncItemCategoryDataDtoList(
    eventId: json["eventId"],
    categoryId: json["categoryId"],
    categoryCode: json["categoryCode"],
    categoryName: json["categoryName"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "eventId": eventId,
    "categoryId": categoryId,
    "categoryCode": categoryCode,
    "categoryName": categoryName,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deleted": deleted,
  };
}



SyncEventRequestModel syncEventRequestModelFromJson(String str) => SyncEventRequestModel.fromJson(json.decode(str));

String syncEventRequestModelToJson(SyncEventRequestModel data) => json.encode(data.toJson());

class SyncEventRequestModel {
  SyncEventRequestModel({
     this.lastSyncAt,
     this.entities,
  });

  int? lastSyncAt;
  List<String>? entities;

  factory SyncEventRequestModel.fromJson(Map<String, dynamic> json) => SyncEventRequestModel(
    lastSyncAt: json["lastSyncAt"],
    entities: List<String>.from(json["entities"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "lastSyncAt": lastSyncAt,
    "entities": List<dynamic>.from(entities!.map((x) => x)),
  };
}

