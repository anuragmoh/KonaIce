class FoodExtraItemsCategories {
  final String id;
  final String categoryName;
  final String type;
  final int minQtyAllowed;
  final int maxQtyAllowed;
  final bool activated;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;
  final String franchiseId;

  FoodExtraItemsCategories(
      {required this.id,
      required this.categoryName,
      required this.type,
      required this.minQtyAllowed,
      required this.maxQtyAllowed,
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
      "category_name": categoryName,
      "type": type,
      "min_qty_allowed": minQtyAllowed,
      "max_qty_allowed": maxQtyAllowed,
      "activated": activated,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_by": updatedBy,
      "updated_at": updatedAt,
      "deleted": deleted,
      "franchise_id": franchiseId
    };
  }

  factory FoodExtraItemsCategories.fromMap(Map<String, dynamic> map) {
    return FoodExtraItemsCategories(
      id: map["id"],
      categoryName: map["category_name"],
      type: map["type"],
      minQtyAllowed: map["min_qty_allowed"],
      maxQtyAllowed: map["max_qty_allowed"],
      activated: map["activated"],
      createdBy: map["created_by"],
      createdAt: map["created_at"],
      updatedBy: map["updated_by"],
      updatedAt: map["updated_at"],
      deleted: map["deleted"],
      franchiseId: map["franchise_id"],
    );
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    categoryName: $categoryName,
    type: $type,
    minQtyAllowed: $minQtyAllowed,
    maxQtyAllowed: $maxQtyAllowed,
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
