class SavedOrdersItem {
  String orderId;
  String itemId;
  String itemName;
  int quantity;
  num unitPrice;
  num totalPrice;
  String itemCategoryId;
  bool deleted;

  SavedOrdersItem(
      {required this.orderId,
      required this.itemId,
      required this.itemName,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      required this.itemCategoryId,
      required this.deleted});

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "itemId": itemId,
      "itemName": itemName,
      "quantity": quantity,
      "unitPrice": unitPrice,
      "totalPrice": totalPrice,
      "itemCategoryId": itemCategoryId,
      "deleted": deleted,
    };
  }

  factory SavedOrdersItem.fromMap(Map<String, dynamic> map) {
    return SavedOrdersItem(
        orderId: map["order_id"],
        itemId: map["item_id"],
        itemName: map["item_name"],
        quantity: map["quantity"],
        unitPrice: map["unit_price"],
        totalPrice: map["total_price"],
        itemCategoryId: map["item_category_id"],
        deleted: map["deleted"] == 1);
  }

  @override
  String toString() {
    return """
      orderId:$orderId,
      itemId:$itemId,
      itemName:$itemName,
      quantity:$quantity,
      unitPrice:$unitPrice,
      totalPrice:$totalPrice,
      itemCategoryId:$itemCategoryId,
      deleted:$deleted
     """;
  }
}
