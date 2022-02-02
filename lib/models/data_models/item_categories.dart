class ItemCategories {
  final String id;
  final String categoryCode;
  final String categoryName;
  final String description;
  final bool activated;
  final String createdBy;
  final int createdAt;
  final String updatedBy;
  final int updatedAt;
  final bool deleted;
  final String franchiseId;

  ItemCategories(
      {required this.id,
      required this.categoryCode,
      required this.categoryName,
      required this.description,
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
      "category_code": categoryCode,
      "category_name": categoryName,
      "description": description,
      "activated": activated,
      "created_by": createdBy,
      "created_at": createdAt,
      "updated_by": updatedBy,
      "updated_at": updatedAt,
      "deleted": deleted,
      "franchise_id": franchiseId,
    };
  }

  factory ItemCategories.fromMap(Map<String, dynamic> map) {
    return ItemCategories(
        id: map["id"],
        categoryCode: map["category_code"],
        categoryName:map["category_name"],
        description: map["description"],
        activated: map["activated"],
        createdBy: map["created_by"],
        createdAt: map["created_at"],
        updatedBy: map["updated_by"],
        updatedAt: map["updated_at"],
        deleted: map["deleted"],
        franchiseId: map["franchise_id"]
    );
  }

  @override
  String toString() {
    return """
    ----------------------------------
    id: $id,
    categoryCode: $categoryCode,
    categoryName: $categoryName,
    description: $description,
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