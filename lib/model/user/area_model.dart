class AreaModel {
  AreaModel({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory AreaModel.fromJson(Map<String, dynamic>? json) => AreaModel(
        id: json?["id"],
        name: json?["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
