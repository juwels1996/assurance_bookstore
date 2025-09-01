import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AdminUnit {
  final int id;
  final String name;
  final String? bn;
  AdminUnit({required this.id, required this.name, this.bn});

  factory AdminUnit.fromJson(Map<String, dynamic> j) {
    final id =
        j['id'] ?? j['division_id'] ?? j['district_id'] ?? j['upazila_id'];
    final name = j['name'] ?? j['english'] ?? j['title'];
    final bn = j['bn_name'] ?? j['bangla'] ?? j['bn'];
    return AdminUnit(
      id: (id is String) ? int.tryParse(id) ?? -1 : (id ?? -1),
      name: name?.toString() ?? '',
      bn: bn?.toString(),
    );
  }
}

class BdGeoService {
  static const _base = 'https://bdapis.vercel.app/geo/v2.0';

  Future<List<AdminUnit>> divisions() async {
    final r = await http.get(Uri.parse('$_base/divisions'));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    final List list = (data is List) ? data : (data['data'] ?? data);
    return list.map((e) => AdminUnit.fromJson(e)).toList();
  }

  Future<List<AdminUnit>> districtsByDivision(int divisionId) async {
    final r = await http.get(Uri.parse('$_base/districts/$divisionId'));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    final List list = (data is List) ? data : (data['data'] ?? data);
    return list.map((e) => AdminUnit.fromJson(e)).toList();
  }

  Future<List<AdminUnit>> upazilasByDistrict(int districtId) async {
    final r = await http.get(Uri.parse('$_base/upazilas/$districtId'));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    final List list = (data is List) ? data : (data['data'] ?? data);
    return list.map((e) => AdminUnit.fromJson(e)).toList();
  }
}

class AddressController extends GetxController {
  final service = BdGeoService();

  var divisions = <AdminUnit>[].obs;
  var districts = <AdminUnit>[].obs;
  var upazilas = <AdminUnit>[].obs;

  var selectedDivisionId = RxnInt();
  var selectedDistrictId = RxnInt();
  var selectedUpazilaId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    loadDivisions();
  }

  Future<void> loadDivisions() async {
    divisions.value = await service.divisions();
  }

  Future<void> onDivisionChanged(int? id) async {
    selectedDivisionId.value = id;
    if (id == null) {
      districts.clear();
      upazilas.clear();
      selectedDistrictId.value = null;
      selectedUpazilaId.value = null;
      return;
    }
    districts.value = await service.districtsByDivision(id);
    upazilas.clear();
    selectedDistrictId.value = null;
    selectedUpazilaId.value = null;
  }

  Future<void> onDistrictChanged(int? id) async {
    selectedDistrictId.value = id;
    if (id == null) {
      upazilas.clear();
      selectedUpazilaId.value = null;
      return;
    }
    upazilas.value = await service.upazilasByDistrict(id);
    selectedUpazilaId.value = null;
  }
}
