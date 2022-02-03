class EventFoodExtraItemMapping{
  final String id;
  final String eventItemId;
  final String eventId;
  final String itemCategoryId;
  final String itemId;
  final String foodExtraCategoryId;
  final String foodExtraItemId;
  final bool activated;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;
  final double price;
  final int sequence;

  EventFoodExtraItemMapping(
      {
        required this.id,
        required this.eventItemId,
        required this.eventId,
        required this.itemCategoryId,
        required this.itemId,
        required this.foodExtraCategoryId,
        required this.foodExtraItemId,
        required this.activated,
        required this.createdBy,
        required this.createdAt,
        required this.updatedBy,
        required this.updatedAt,
        required this.deleted,
        required this.price,
        required this.sequence});


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "event_item_id": eventItemId,
      "event_id": eventId,
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

  factory EventFoodExtraItemMapping.fromMap(Map<String, dynamic> map) {
    return EventFoodExtraItemMapping(
      id: map["id"],
      eventItemId : map["event_item_id"],
      eventId: map["event_id"],
      itemCategoryId :map["item_category_id"],
      itemId: map["item_id"],
      foodExtraCategoryId: map["food_extra_category_id"],
      foodExtraItemId: map["food_extra_item_id"],
      activated:map["activated"],
      createdBy: map["created_by"],
      createdAt: map["created_at"],
      updatedBy: map["updated_by"],
      updatedAt: map["updated_at"],
      deleted: map["deleted"],
      price :map["price"],
      sequence: map["sequence"],
    );
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    eventItemId: $eventItemId,
    eventId: $eventId,
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