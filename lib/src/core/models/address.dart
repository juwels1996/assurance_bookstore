class Address {
  int? id;
  dynamic addressName;
  String? phone;
  String? email;
  String? address;
  String? postalCode;
  String? district;
  String? thana;
  bool? primary;
  String? areaName;
  int? areaId;
  int? zoneId;
  DateTime? createdDate;
  DateTime? updatedDate;
  int? user;

  Address({
    this.id,
    this.addressName,
    this.phone,
    this.email,
    this.address,
    this.postalCode,
    this.district,
    this.thana,
    this.areaName,
    this.areaId,
    this.zoneId,
    this.primary,
    this.createdDate,
    this.updatedDate,
    this.user,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    addressName: json["address_name"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    postalCode: json["postal_code"],
    district: json["district"],
    thana: json["thana"],
    primary: json["primary"],
    areaName: json["area_name"],
    areaId: json["area_id"],
    zoneId: json["zone_id"],
    createdDate: json["created_date"] == null
        ? null
        : DateTime.parse(json["created_date"]),
    updatedDate: json["updated_date"] == null
        ? null
        : DateTime.parse(json["updated_date"]),
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address_name": addressName,
    "phone": phone,
    "email": email,
    "address": address,
    "postal_code": postalCode,
    "district": district,
    "thana": thana,
    "primary": primary,
    "area_name": areaName,
    "area_id": areaId,
    "zone_id": zoneId,
    "created_date": createdDate?.toIso8601String(),
    "updated_date": updatedDate?.toIso8601String(),
    "user": user,
  };
}
