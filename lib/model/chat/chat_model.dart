class ChatModel {
  ChatModel({
    this.id,
    this.message,
    this.dateCreated,
  });

  String? id;
  String? message;
  String? dateCreated;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        message: json["message"],
        dateCreated: json["date_created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "date_created": dateCreated,
      };
}
