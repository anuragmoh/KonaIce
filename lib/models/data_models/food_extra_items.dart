class FoodExtraItems {
  final String id;
  final String foodExtraItemCategoryId;
  final String itemId;
  final String eventId;
  final String itemName;
  final num sellingPrice;
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
  final int sequence;
  int selectedItemQuantity = 0;
  bool isItemSelected = false;

  FoodExtraItems(
      {required this.id,
      required this.foodExtraItemCategoryId,
      required this.itemId,
      required this.eventId,
      required this.itemName,
      required this.sellingPrice,
      required this.selection,
      required this.imageFileId,
      required this.minQtyAllowed,
      required this.maxQtyAllowed,
      required this.activated,
      required this.sequence,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt,
      required this.deleted});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "food_extra_item_category_id": foodExtraItemCategoryId,
      "item_id": itemId,
      "event_id": eventId,
      "item_name": itemName,
      "selling_price": sellingPrice,
      "selection": selection,
      "image_file_id": imageFileId,
      "min_qty_allowed": minQtyAllowed,
      "max_qty_allowed": maxQtyAllowed,
      "activated": activated,
      "sequence":sequence,
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
        itemId: map["item_id"],
        eventId: map["event_id"],
        itemName: map["item_name"],
        sellingPrice: map["selling_price"],
        selection: map["selection"],
        imageFileId: map["image_file_id"],
        minQtyAllowed: map["min_qty_allowed"],
        maxQtyAllowed: map["max_qty_allowed"],
        activated: map["activated"] == 1,
        sequence:map["sequence"],
        createdBy: map["created_by"],
        createdAt: map["created_at"],
        updatedBy: map["updated_by"],
        updatedAt: map["updated_at"],
        deleted: map["deleted"] == 1);
  }

  @override
  String toString() {
    return """
    id: $id,
    foodExtraItemCategoryId: $foodExtraItemCategoryId,
    itemId: $itemId,
    eventId: $eventId,
    itemName: $itemName,
    sellingPrice: $sellingPrice,
    selection: $selection,
    imageFileId: $imageFileId,
    minQtyAllowed: $minQtyAllowed,
    maxQtyAllowed: $maxQtyAllowed,
    activated: $activated,
    sequence:$sequence,
    createdBy: $createdBy,
    createdAt: $createdAt,
    updatedBy: $updatedBy,
    updatedAt: $updatedAt,
    deleted: $deleted,
    """;
  }

  FoodExtraItems getCopy() {
    //   return FoodExtraItems(id: this.id, foodExtraItemCategoryId: this.foodExtraItemCategoryId, itemId: this.itemId, eventId: this.eventId, itemName: itemName,
    // sellingPrice: this.sellingPrice, selection: this.selection, imageFileId: this.imageFileId, minQtyAllowed: this.minQtyAllowed, maxQtyAllowed: this.maxQtyAllowed, activated: this.activated,
    // createdBy: this.createdBy, createdAt: this.createdAt, updatedBy: this.updatedBy, updatedAt: this.updatedAt, deleted: this.deleted);
    return FoodExtraItems(
        id: id,
        foodExtraItemCategoryId: foodExtraItemCategoryId,
        itemId: itemId,
        eventId: eventId,
        itemName: itemName,
        sellingPrice: sellingPrice,
        selection: selection,
        imageFileId: imageFileId,
        minQtyAllowed: minQtyAllowed,
        maxQtyAllowed: maxQtyAllowed,
        activated: activated,
        sequence:sequence,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedBy: updatedBy,
        updatedAt: updatedAt,
        deleted: deleted);
  }

  double getTotalPrice() {
    return selectedItemQuantity * sellingPrice.toDouble();
  }
}
