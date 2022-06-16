import 'dart:convert';

import 'package:kona_ice_pos/models/network_model/order_model/order_response_model.dart';

AllOrderResponse allOrderResponseFromJson(String str) =>
    AllOrderResponse.fromJson(json.decode(str));

String allOrderResponseToJson(AllOrderResponse data) =>
    json.encode(data.toJson());

class AllOrderResponse {
  AllOrderResponse({
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
  String? searchText;
  List<PlaceOrderResponseModel>? data;
  int? fromDate;
  int? toDate;

  factory AllOrderResponse.fromJson(Map<String, dynamic> json) =>
      AllOrderResponse(
        count: json["count"],
        limit: json["limit"],
        offset: json["offset"],
        sortColumn: json["sortColumn"],
        sortType: json["sortType"],
        searchText: json["searchText"],
        data: List<PlaceOrderResponseModel>.from(json["data"].map((x) => PlaceOrderResponseModel.fromJson(x))),
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

class OrderItemsList {
  OrderItemsList({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.orderId,
    this.quantity,
    this.itemId,
    this.itemCategoryId,
    this.name,
    this.totalAmount,
    this.foodExtraItemMappingList,
    this.unitPrice,
    this.key,
    this.values,
    this.recipientName,
  });

  String? id;
  int? createdAt;
  int? updatedAt;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? orderId;
  int? quantity;
  String? itemId;
  String? itemCategoryId;
  String? name;
  double? totalAmount;
  List<FoodExtraItemMappingList>? foodExtraItemMappingList;
  double? unitPrice;
  String? key;
  String? values;
  String? recipientName;

  factory OrderItemsList.fromJson(Map<String, dynamic> json) => OrderItemsList(
        id: json["id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        deleted: json["deleted"],
        orderId: json["orderId"],
        quantity: json["quantity"],
        itemId: json["itemId"],
        itemCategoryId: json["itemCategoryId"],
        name: json["name"],
        totalAmount: json["totalAmount"],
        foodExtraItemMappingList: List<FoodExtraItemMappingList>.from(
            json["foodExtraItemMappingList"]
                .map((x) => FoodExtraItemMappingList.fromJson(x))),
        unitPrice: json["unitPrice"],
        key: json["key"],
        values: json["values"],
        recipientName: json["recipientName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "deleted": deleted,
        "orderId": orderId,
        "quantity": quantity,
        "itemId": itemId,
        "itemCategoryId": itemCategoryId,
        "name": name,
        "totalAmount": totalAmount,
        "foodExtraItemMappingList": List<dynamic>.from(
            foodExtraItemMappingList!.map((x) => x.toJson())),
        "unitPrice": unitPrice,
        "key": key,
        "values": values,
        "recipientName": recipientName,
      };
}

class FoodExtraItemMappingList {
  FoodExtraItemMappingList({
    this.foodExtraCategoryId,
    this.foodExtraCategoryName,
    this.orderFoodExtraItemDetailDto,
  });

  String? foodExtraCategoryId;
  dynamic foodExtraCategoryName;
  List<OrderFoodExtraItemDetailDto>? orderFoodExtraItemDetailDto;

  factory FoodExtraItemMappingList.fromJson(Map<String, dynamic> json) =>
      FoodExtraItemMappingList(
        foodExtraCategoryId: json["foodExtraCategoryId"],
        foodExtraCategoryName: json["foodExtraCategoryName"],
        orderFoodExtraItemDetailDto: List<OrderFoodExtraItemDetailDto>.from(
            json["orderFoodExtraItemDetailDto"]
                .map((x) => OrderFoodExtraItemDetailDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foodExtraCategoryId": foodExtraCategoryId,
        "foodExtraCategoryName": foodExtraCategoryName,
        "orderFoodExtraItemDetailDto": List<dynamic>.from(
            orderFoodExtraItemDetailDto!.map((x) => x.toJson())),
      };
}

class OrderFoodExtraItemDetailDto {
  OrderFoodExtraItemDetailDto({
    this.id,
    this.foodExtraItemName,
    this.quantity,
    this.unitPrice,
    this.totalAmount,
    this.specialInstructions,
  });

  String? id;
  String? foodExtraItemName;
  int? quantity;
  double? unitPrice;
  double? totalAmount;
  dynamic specialInstructions;

  factory OrderFoodExtraItemDetailDto.fromJson(Map<String, dynamic> json) =>
      OrderFoodExtraItemDetailDto(
        id: json["id"],
        foodExtraItemName: json["foodExtraItemName"],
        quantity: json["quantity"],
        unitPrice: json["unitPrice"],
        totalAmount: json["totalAmount"],
        specialInstructions: json["specialInstructions"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "foodExtraItemName": foodExtraItemName,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "totalAmount": totalAmount,
        "specialInstructions": specialInstructions,
      };
}
