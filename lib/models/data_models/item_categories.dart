import 'package:kona_ice_pos/common/extensions/string_extension.dart';

class ItemCategories {
  final String id;
  final String eventId;
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
      required this.eventId,
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
      "event_id": eventId,
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
        eventId: map["event_id"],
        categoryCode: map["category_code"],
        categoryName: map["category_name"],
        description: map["description"],
        activated: map["activated"] == 1,
        createdBy: map["created_by"],
        createdAt: map["created_at"],
        updatedBy: map["updated_by"],
        updatedAt: map["updated_at"],
        deleted: map["deleted"] == 1,
        franchiseId: map["franchise_id"]);
  }

  @override
  String toString() {
    return """
    id: $id,
    eventId:$eventId,
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
    """;
  }

  static ItemCategories getCustomMenuCategory(
      {required String eventId, required String name}) {
    return ItemCategories(
        id: "1",
        eventId: eventId,
        categoryCode: "0",
        categoryName: name,
        description: StringExtension.empty(),
        activated: false,
        createdBy: StringExtension.empty(),
        createdAt: 0,
        updatedBy: StringExtension.empty(),
        updatedAt: 0,
        deleted: false,
        franchiseId: StringExtension.empty());
  }
}
