import 'area_model.dart';

class UserModel {
  UserModel({
    this.id,
    this.birthDate,
    this.birthPlace,
    this.dateCreated,
    this.dateUpdated,
    this.gender,
    this.religion,
    this.address,
    this.imageUrl,
    this.name,
    this.phone,
    this.role,
    this.city,
    this.district,
    this.village,
  });

  String? id;
  String? birthDate;
  String? birthPlace;
  String? dateCreated;
  String? dateUpdated;
  String? gender;
  String? religion;
  String? address;
  String? imageUrl;
  String? name;
  String? phone;
  int? role;
  AreaModel? city;
  AreaModel? district;
  AreaModel? village;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        birthDate: json["birth_date"],
        birthPlace: json["birth_place"],
        dateCreated: json["date_created"],
        dateUpdated: json["date_updated"],
        gender: json["gender"],
        religion: json["religion"],
        address: json["address"],
        imageUrl: json["image_url"],
        name: json["name"],
        phone: json["phone"],
        role: json["role"],
        city: json["city"] != null ? AreaModel?.fromJson(json["city"]) : null,
        district: json["district"] != null
            ? AreaModel?.fromJson(json["district"])
            : null,
        village: json["village"] != null
            ? AreaModel?.fromJson(json["village"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "birth_date": birthDate,
        "birth_place": birthPlace,
        "date_created": dateCreated,
        "date_updated": dateUpdated,
        "gender": gender,
        "religion": religion,
        "address": address,
        "image_url": imageUrl,
        "name": name,
        "phone": phone,
        "role": role,
        "city": city?.toJson(),
        "district": district?.toJson(),
        "village": village?.toJson(),
      };
}
