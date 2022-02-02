class EventItem {
  final String id;
  final String itemId;
  final String eventId;
  final double price;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;
  final int sequence;
  final bool gift;
  final String itemCategoryId;
  final int soldQty;
  final int compQty;

  EventItem(
      {required this.id,
      required this.itemId,
      required this.eventId,
      required this.price,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt,
      required this.deleted,
      required this.sequence,
      required this.gift,
      required this.itemCategoryId,
      required this.soldQty,
      required this.compQty});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "item_id": itemId,
      "event_id": eventId,
      "price": price,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_by": updatedBy,
      "updated_at": updatedAt,
      "deleted": deleted,
      "sequence": sequence,
      "gift": gift,
      "item_category_id": itemCategoryId,
      "sold_qty": soldQty,
      "comp_qty": compQty
    };
  }

  factory EventItem.fromMap(Map<String, dynamic> map) {
    return EventItem(
      id: map["id"],
      itemId: map["item_id"],
      eventId: map["event_id"],
      price: map["price"],
      createdBy: map["created_by"],
      createdAt: map["created_at"],
      updatedBy: map["updated_by"],
      updatedAt: map["updated_at"],
      deleted: map["deleted"],
      sequence: map["sequence"],
      gift: map["gift"],
      itemCategoryId: map["item_category_id"],
      soldQty: map["sold_qty"],
      compQty: map["comp_qty"],
    );
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    itemId: $itemId,
    eventId: $eventId,
    price: $price,
    createdBy: $createdBy,
    createdAt: $createdAt,
    updatedBy: $updatedBy,
    updatedAt: $updatedAt,
    deleted: $deleted,
    sequence: $sequence
     gift: $gift,
    itemCategoryId: $itemCategoryId,
    soldQty: $soldQty,
    compQty: $compQty
    
    ----------------------------------
    """;
  }
}
