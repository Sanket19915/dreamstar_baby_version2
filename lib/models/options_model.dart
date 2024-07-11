// To parse this JSON data, do
//
//     final optionsModel = optionsModelFromJson(jsonString);

import 'dart:convert';

List<OptionsModel> optionsModelFromJson(String str) => List<OptionsModel>.from(
    json.decode(str).map((x) => x == null || (x is! Map<String, dynamic>)
        ? OptionsModel()
        : OptionsModel.fromJson(x)));

String optionsModelToJson(List<OptionsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OptionsModel {
  String text;
  String image;
  OptionsModel({
    this.text = "",
    this.image = "",
  });

  factory OptionsModel.fromJson(Map<String, dynamic> json) => OptionsModel(
        text: json["text"] ?? "",
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "image": image,
      };
}
