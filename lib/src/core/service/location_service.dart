// // lib/data/bd_api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class BdApiService {
//   final String baseUrl;
//   BdApiService({this.baseUrl = 'https://bdapis.com/api/v1.2'});
//
//   Future<List<District>> fetchDistricts() async {
//     final res = await http.get(Uri.parse('$baseUrl/districts'));
//     if (res.statusCode != 200) throw Exception('Districts fetch failed');
//     final data = jsonDecode(res.body);
//     final List list = (data['data'] ?? []) as List;
//     return list.map((e) => District.fromJson(e)).toList();
//   }
//
//   Future<List<String>> fetchUpazilas(String districtEn) async {
//     // NOTE: API expects English district name (e.g., "Dhaka")
//     final safe = Uri.encodeComponent(districtEn);
//     final res = await http.get(Uri.parse('$baseUrl/district/$safe'));
//     if (res.statusCode != 200) throw Exception('Upazila fetch failed');
//     final data = jsonDecode(res.body);
//     // API shape: { data: { district: "...", upazilla: [ "Savar", "Dhamrai", ... ] } } or
//     // sometimes data is an array; handle both
//     final d = data['data'];
//     if (d is Map && d['upazilla'] is List) {
//       return (d['upazilla'] as List).cast<String>();
//     }
//     if (d is List && d.isNotEmpty && d.first['upazilla'] is List) {
//       return (d.first['upazilla'] as List).cast<String>();
//     }
//     return <String>[];
//   }
// }
//
// class District {
//   final String en;
//   final String bn;
//   District({required this.en, required this.bn});
//   factory District.fromJson(Map<String, dynamic> j) =>
//       District(en: j['district'] ?? '', bn: j['districtbn'] ?? '');
// }
