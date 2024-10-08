import '../user/gender_model.dart';
import '../user/user_model.dart';

class ScheduleModel {
  String? id;
  MenuItemModel? medium;
  MenuItemModel? serviceType;
  UserModel? client;
  UserModel? conselor;
  int? status;
  String? dateTime;
  String? dateCreated;
  String? roomId;
  String? adminMessage;

  ScheduleModel({
    this.id,
    this.medium,
    this.serviceType,
    this.client,
    this.conselor,
    this.status,
    this.dateTime,
    this.dateCreated,
    this.roomId,
    this.adminMessage,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        id: json["id"],
        medium: json["medium"] != null
            ? MenuItemModel?.fromJson(json["medium"])
            : null,
        serviceType: json["service_type"] != null
            ? MenuItemModel?.fromJson(json["service_type"])
            : null,
        client:
            json["client"] != null ? UserModel?.fromJson(json["client"]) : null,
        conselor: json["conselor"] != null
            ? UserModel?.fromJson(json["conselor"])
            : null,
        status: json["status"],
        dateTime: json["date_time"],
        dateCreated: json["date_created"],
        roomId: json["room_id"],
        adminMessage: json["admin_message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medium": medium?.toJson(),
        "service_type": serviceType?.toJson(),
        "client": client?.toJson(),
        "conselor": conselor?.toJson(),
        "status": status,
        "date_time": dateTime,
        "date_created": dateCreated,
        "room_id": roomId,
        "admin_message": adminMessage,
      };
}
