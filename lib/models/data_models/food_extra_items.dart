class FoodExtraItems {
  final String id;
  final String foodExtraItemCategoryId;
  final String itemName;
  final double sellingPrice;
  final String selection;
  final String imageFileId;
  final int minQtyAllowed;
  final int maxQtyAllowed;
  final bool activated;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;

  FoodExtraItems(
      {required this.id,
      required this.foodExtraItemCategoryId,
      required this.itemName,
      required this.sellingPrice,
      required this.selection,
      required this.imageFileId,
      required this.minQtyAllowed,
      required this.maxQtyAllowed,
      required this.activated,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt,
      required this.deleted});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "food_extra_item_category_id": foodExtraItemCategoryId,
      "item_name": itemName,
      "selling_price": sellingPrice,
      "selection": selection,
      "image_file_id": imageFileId,
      "min_qty_allowed": minQtyAllowed,
      "max_qty_allowed": maxQtyAllowed,
      "activated": activated,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_by": updatedBy,
      "updated_at": updatedAt,
      "deleted": deleted
    };
  }

  factory FoodExtraItems.fromMap(Map<String, dynamic> map) {
    return FoodExtraItems(
        id: map["id"],
        foodExtraItemCategoryId: map["food_extra_item_category_id"],
        itemName: map["item_name"],
        sellingPrice: map["selling_price"],
        selection: map["selection"],
        imageFileId: map["image_file_id"],
        minQtyAllowed: map["min_qty_allowed"],
        maxQtyAllowed: map["max_qty_allowed"],
        activated: map["activated"],
        createdBy: map["created_by"],
        createdAt: map["created_at"],
        updatedBy: map["updated_by"],
        updatedAt: map["updated_at"],
        deleted: map["deleted"]);
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    foodExtraItemCategoryId: $foodExtraItemCategoryId,
    itemName: $itemName,
    sellingPrice: $sellingPrice,
    selection: $selection,
    imageFileId: $imageFileId,
    minQtyAllowed: $minQtyAllowed,
    maxQtyAllowed: $maxQtyAllowed,
    activated: $activated,
    createdBy: $createdBy,
    createdAt: $createdAt,
    updatedBy: $updatedBy,
    updatedAt: $updatedAt,
    deleted: $deleted,

    
    ----------------------------------
    """;
  }
}
