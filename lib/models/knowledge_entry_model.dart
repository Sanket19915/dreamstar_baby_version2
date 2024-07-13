// To parse this JSON data, do
//
//     final knowledgeEntryModel = knowledgeEntryModelFromJson(jsonString);

import 'dart:convert';

List<KnowledgeEntryModel> knowledgeEntryModelFromJson(String str) =>
    List<KnowledgeEntryModel>.from(
        json.decode(str).map((x) => KnowledgeEntryModel.fromJson(x)));

String knowledgeEntryModelToJson(List<KnowledgeEntryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KnowledgeEntryModel {
  int? id;
  String? name;
  String? category;
  String? mediaType;
  String? filePath;
  String? backgroundImage;
  DateTime? createdAt;
  DateTime? updatedAt;

  KnowledgeEntryModel({
    this.id,
    this.name,
    this.category,
    this.mediaType,
    this.filePath,
    this.backgroundImage,
    this.createdAt,
    this.updatedAt,
  });

  factory KnowledgeEntryModel.fromJson(Map<String, dynamic> json) =>
      KnowledgeEntryModel(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        mediaType: json["media_type"],
        filePath: json["file_path"],
        backgroundImage: json["background_image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "media_type": mediaType,
        "background_image":backgroundImage,
        "file_path": filePath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
