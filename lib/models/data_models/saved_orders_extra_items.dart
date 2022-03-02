class SavedOrdersExtraItems {
  String orderId;
  String itemId;
  String extraFoodItemId;
  String extraFoodItemName;
  String extraFoodItemCategoryId;
  int quantity;
  num unitPrice;
  num totalPrice;
  bool deleted;

  SavedOrdersExtraItems(
      {
      required this.orderId,
      required this.itemId,
      required this.extraFoodItemId,
      required this.extraFoodItemName,
      required this.extraFoodItemCategoryId,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      required this.deleted});

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "itemId": itemId,
      "extraFoodItemId": extraFoodItemId,
      "extraFoodItemName": extraFoodItemName,
      "extraFoodItemCategoryId": extraFoodItemCategoryId,
      "quantity": quantity,
      "unitPrice": unitPrice,
      "totalPrice": totalPrice,
      "deleted": deleted,
    };
  }

  factory SavedOrdersExtraItems.fromMap(Map<String, dynamic> map) {
    return SavedOrdersExtraItems(
        orderId: map["order_id"],
        itemId: map["item_id"],
        extraFoodItemId: map["extra_food_item_id"],
        extraFoodItemName: map["extra_food_item_name"],
        extraFoodItemCategoryId: map["extra_food_item_category_id"],
        quantity: map["quantity"],
        unitPrice: map["unit_price"],
        totalPrice: map["total_price"],
        deleted: map["deleted"] == 1);
  }

  @override
  String toString() {
    return """
      orderId:$orderId,
      itemId:$itemId,
      extraFoodItemId:$extraFoodItemId,
      extraFoodItemName:$extraFoodItemName,
      extraFoodItemCategoryId:$extraFoodItemCategoryId,
      quantity:$quantity,
      unitPrice:$unitPrice,
      totalPrice:$totalPrice,
      deleted:$deleted
     """;
  }
}
