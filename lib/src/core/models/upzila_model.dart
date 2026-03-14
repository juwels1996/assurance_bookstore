// To parse this JSON data, do
//
//     final thanaModel = thanaModelFromJson(jsonString);

import 'dart:convert';

import 'package:assurance_bookstore/src/core/models/upazilla.dart';


UpazilaModel upazilaModelFromJson(String str) => UpazilaModel.fromJson(json.decode(str));

String upazilaModelToJson(UpazilaModel data) => json.encode(data.toJson());

class UpazilaModel {
  List<Upazila> upazilas;

  UpazilaModel({
    required this.upazilas,
  });

  factory UpazilaModel.fromJson(Map<String, dynamic> json) => UpazilaModel(
    upazilas: json["upazilas"] == null ? [] : List<Upazila>.from(json["upazilas"]!.map((x) => Upazila.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "upazilas": List<dynamic>.from(upazilas.map((x) => x.toJson())),
  };
}