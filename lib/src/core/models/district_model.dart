// // To parse this JSON data, do
// //
// //     final districtModel = districtModelFromJson(jsonString);
//
// import 'dart:convert';
//
// import 'districts.dart';
//
// DistrictModel districtModelFromJson(String str) =>
//     DistrictModel.fromJson(json.decode(str));
//
// class DistrictModel {
//   List<District> districts;
//
//   DistrictModel({required this.districts});
//
//   factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
//     districts: json["districts"] == null
//         ? []
//         : List<District>.from(
//             json["districts"]!.map((x) => District.fromJson(x)),
//           ),
//   );
// }
