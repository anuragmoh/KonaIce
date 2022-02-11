class Item {
  final String id;
  final String eventId;
  final String itemCategoryId;
  final String imageFileId;
  final String itemCode;
  final String name;
  final String description;
  final double price;
  final bool activated;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;
  final String franchiseId;

  Item(
      {required this.id,
        required this.eventId,
      required this.itemCategoryId,
      required this.imageFileId,
      required this.itemCode,
      required this.name,
      required this.description,
      required this.price,
      required this.activated,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt,
      required this.deleted,
      required this.franchiseId});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "event_id":eventId,
      "item_category_id": itemCategoryId,
      "image_file_id": imageFileId,
      "item_code": itemCode,
      "name": name,
      "description": description,
      "price": price,
      "activated": activated,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_by": updatedBy,
      "updated_at": updatedAt,
      "deleted": deleted,
      "franchise_id": franchiseId
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map["id"],
        eventId:map["event_id"],
        itemCategoryId: map["item_category_id"],
        imageFileId: map["image_file_id"],
        itemCode: map["item_code"],
        name: map["name"],
        description: map["description"],
        price: map["price"],
        activated: map["activated"],
        createdBy: map["created_by"],
        createdAt: map["created_at"],
        updatedBy: map["updated_by"],
        updatedAt: map["updated_at"],
        deleted: map["deleted"],
        franchiseId: map["franchise_id"]);
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    eventId:$eventId,
    itemCategoryId: $itemCategoryId,
    imageFileId: $imageFileId,
    itemCode: $itemCode,
    name: $name,
    description: $description,
    price: $price,
    activated: $activated,
    createdBy: $createdBy,
    createdAt: $createdAt,
    updatedBy: $updatedBy,
    updatedAt: $updatedAt,
    deleted: $deleted,
    franchiseId: $franchiseId
    
    ----------------------------------
    """;
  }
}
