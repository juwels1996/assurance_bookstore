class Upazila {
  String? id;
  String? districtId;
  String name;

  Upazila({
    this.id,
    this.districtId,
    required this.name,
  });

  factory Upazila.fromJson(Map<String, dynamic> json) => Upazila(
    id: json["id"],
    districtId: json["district_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "district_id": districtId,
    "name": name,
  };
}