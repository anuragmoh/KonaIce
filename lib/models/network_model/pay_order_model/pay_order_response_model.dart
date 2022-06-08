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

class OrderItemList {
  OrderItemList({
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
  List<dynamic>? foodExtraItemMappingList;
  double? unitPrice;
  String? key;
  String? values;
  String? recipientName;

  factory OrderItemList.fromJson(Map<String?, dynamic> json) => OrderItemList(
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
        totalAmount: json["totalAmount"].toDouble(),
        foodExtraItemMappingList:
            List<dynamic>.from(json["foodExtraItemMappingList"].map((x) => x)),
        unitPrice: json["unitPrice"].toDouble(),
        key: json["key"],
        values: json["values"],
        recipientName: json["recipientName"],
      );

  Map<String?, dynamic> toJson() => {
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
        "foodExtraItemMappingList":
            List<dynamic>.from((foodExtraItemMappingList ?? []).map((x) => x)),
        "unitPrice": unitPrice,
        "key": key,
        "values": values,
        "recipientName": recipientName,
      };
}
