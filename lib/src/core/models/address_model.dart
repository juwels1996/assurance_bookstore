// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';
import 'address.dart';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  String? message;
  bool? error;
  List<Address>? addressList;

  AddressModel({this.message, this.error, this.addressList});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    message: json["message"],
    error: json["error"],
    addressList: json["address_list"] == null
        ? []
        : List<Address>.from(
            json["address_list"]!.map((x) => Address.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "error": error,
    "address_list": addressList == null
        ? []
        : List<dynamic>.from(addressList!.map((x) => x.toJson())),
  };
}
