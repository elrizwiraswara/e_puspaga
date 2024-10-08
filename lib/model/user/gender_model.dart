class MenuItemModel {
  MenuItemModel({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
