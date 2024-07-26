// To parse this JSON data, do
//
//     final questionsModel = questionsModelFromJson(jsonString);

import 'dart:convert';

import 'package:dream_baby/models/options_model.dart';

QuestionsModel questionsModelFromJson(String str) =>
    QuestionsModel.fromJson(json.decode(str));

String questionsModelToJson(QuestionsModel data) => json.encode(data.toJson());

class QuestionsModel {
  Questions? questions;
  List<dynamic> flaggedQuestions;

  QuestionsModel({
    this.questions,
    this.flaggedQuestions = const [],
  });

  factory QuestionsModel.fromJson(Map<String, dynamic> json) => QuestionsModel(
        questions: Questions.fromJson(json["questions"]),
        flaggedQuestions: ((json["flagged_questions"] == null) &&
                (json["flagged_questions"] == []))
            ? []
            : List<dynamic>.from(json["flagged_questions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "questions": questions?.toJson(),
        "flagged_questions": List<dynamic>.from(flaggedQuestions.map((x) => x)),
      };
}

class Questions {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Questions({
    this.currentPage = 0,
    this.data = const [],
    this.firstPageUrl = "",
    this.from = 0,
    this.lastPage = 0,
    this.lastPageUrl = "",
    this.links = const [],
    this.nextPageUrl,
    this.path = "",
    this.perPage = 0,
    this.prevPageUrl,
    this.to = 0,
    this.total = 0,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        currentPage: json["current_page"] ?? 0,
        data: (json["data"] == [] && json["data"] == null)
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"] ?? "",
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        lastPageUrl: json["last_page_url"] ?? "",
        links: (json["links"] == null && json["links"] == [])
            ? []
            : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"] ?? "",
        perPage: json["per_page"] ?? 0,
        prevPageUrl: json["prev_page_url"],
        to: json["to"] ?? 0,
        total: json["total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int id;
  String quotient;
  String intelligenceType;
  String week;
  String day;
  String questionType;
  String questionCode;
  String questionText;
  String questionDescription;
  String mainImage;
  dynamic mainImage2;
  dynamic mainVideo;
  dynamic mainVideo2;
  dynamic mainAudio;
  dynamic mainAudio2;
  String youtubeLink;
  List<OptionsModel> options;
  List<dynamic> correctAnswer;
  bool feedback;
  String answerKeyInput;
  dynamic answerImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isPurposeExpanded;

  Datum({
    this.id = 0,
    this.quotient = "",
    this.intelligenceType = "",
    this.week = "",
    this.day = "",
    this.questionType = "",
    this.questionCode = "",
    this.questionText = "",
    this.questionDescription = "",
    this.mainImage = "",
    this.mainImage2,
    this.mainVideo,
    this.mainVideo2,
    this.mainAudio,
    this.mainAudio2,
    this.youtubeLink = "",
    this.options = const [],
    this.correctAnswer = const [],
    this.feedback = false,
    this.answerKeyInput = "",
    this.answerImage,
    this.createdAt,
    this.updatedAt,
    this.isPurposeExpanded = true,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        quotient: json["quotient"] ?? "",
        intelligenceType: json["intelligence_type"] ?? "",
        week: json["week"] ?? "",
        day: json["day"] ?? "",
        questionType: json["question_type"] ?? "",
        questionCode: json["question_code"] ?? "",
        questionText: json["question_text"] ?? "",
        questionDescription: json["question_description"] ?? "",
        mainImage: json["main_image"] ?? "",
        mainImage2: json["main_image2"],
        mainVideo: json["main_video"],
        mainVideo2: json["main_video2"],
        mainAudio: json["main_audio"],
        mainAudio2: json["main_audio2"],
        youtubeLink: json["youtube_link"] ?? "",
        options: (json["options"] == null && json["options"] == [])
            ? []
            : (optionsModelFromJson(json["options"])
                    .where((element) => element.text.isNotEmpty)
                    .toList() ??
                []),
        
        correctAnswer:  jsonDecode(json["correct_answer"] )  ,
        feedback: json["feedback"] ?? false,
        answerKeyInput: json["answer_key_input"] ?? "",
        answerImage: json["answer_image"],
        createdAt: (json["created_at"] == null)
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: (json["updated_at"] == null)
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quotient": quotient,
        "intelligence_type": intelligenceType,
        "week": week,
        "day": day,
        "question_type": questionType,
        "question_code": questionCode,
        "question_text": questionText,
        "question_description": questionDescription,
        "main_image": mainImage,
        "main_image2": mainImage2,
        "main_video": mainVideo,
        "main_video2": mainVideo2,
        "main_audio": mainAudio,
        "main_audio2": mainAudio2,
        "youtube_link": youtubeLink,
        "options": options,
        "correct_answer": correctAnswer,
        "feedback": feedback,
        "answer_key_input": answerKeyInput,
        "answer_image": answerImage,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Link {
  String url;
  String label;
  bool active;

  Link({
    this.url = "",
    this.label = "",
    this.active = false,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] ?? "",
        label: json["label"] ?? "",
        active: json["active"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
