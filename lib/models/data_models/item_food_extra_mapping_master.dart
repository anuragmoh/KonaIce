class ItemFoodExtraMappingMaster {
  final String id;
  final String itemCategoryId;
  final String itemId;
  final String foodExtraCategoryId;
  final String foodExtraItemId;
  final double price;
  final int sequence;
  final bool activated;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;

  ItemFoodExtraMappingMaster(
      {required this.id,
      required this.itemCategoryId,
      required this.itemId,
      required this.foodExtraCategoryId,
      required this.foodExtraItemId,
      required this.price,
      required this.sequence,
      required this.activated,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt,
      required this.deleted});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "item_category_id": itemCategoryId,
      "item_id": itemId,
      "food_extra_category_id": foodExtraCategoryId,
      "food_extra_item_id": foodExtraItemId,
      "activated": activated,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_by": updatedBy,
      "updated_at": updatedAt,
      "deleted": deleted,
      "price": price,
      "sequence": sequence,
    };
  }

  factory ItemFoodExtraMappingMaster.fromMap(Map<String, dynamic> map) {
    return ItemFoodExtraMappingMaster(
      id: map["id"],
      itemCategoryId: map["item_category_id"],
      itemId: map["item_id"],
      foodExtraCategoryId: map["food_extra_category_id"],
      foodExtraItemId: map["food_extra_item_id"],
      activated: map["activated"],
      createdBy: map["created_by"],
      createdAt: map["created_at"],
      updatedBy: map["updated_by"],
      updatedAt: map["updated_at"],
      deleted: map["deleted"],
      price: map["price"],
      sequence: map["sequence"],
    );
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    itemCategoryId:$itemCategoryId,
    itemId: $itemId,
    foodExtraCategoryId:$foodExtraCategoryId,
    foodExtraItemId:$foodExtraItemId,
    activated:$activated,
    createdBy: $createdBy,
    createdAt: $createdAt,
    updatedBy: $updatedBy,
    updatedAt: $updatedAt,
    deleted: $deleted,
    price: $price,
    sequence: $sequence
  
    
    ----------------------------------
    """;
  }
}
