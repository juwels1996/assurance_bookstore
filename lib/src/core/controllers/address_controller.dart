// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/instance_manager.dart';
// import 'package:flutter/services.dart' show rootBundle;
//
// import '../models/address_model.dart';
// import '../models/district_model.dart';
// import '../models/districts.dart';
// import '../models/upazilla.dart';
// import '../models/upzila_model.dart';
//
// class AddressController extends GetxController with StateMixin<AddressModel> {
//   Rx<UpazilaModel?> upazilaModel = Rx<UpazilaModel?>(null);
//   Rx<DistrictModel?> districtModel = Rx<DistrictModel?>(null);
//
//   Rx<AddressModel?> addressModel = Rx<AddressModel?>(null);
//   RxBool isEditAddress = false.obs;
//   RxInt updateAbleId = (-1).obs;
//   RxInt selectedAddressId = (-1).obs;
//   Rx<District?> selectedDistrict = Rx<District?>(null);
//   Rx<Upazila?> selectedUpazila = Rx<Upazila?>(null);
//   RxList<Upazila> searchAbleUpazila = <Upazila>[].obs;
//   RxList<District> searchAbleDistrict = <District>[].obs;
//   RxList<Upazila> selectedDistrictWiseUpazila = <Upazila>[].obs;
//   RxDouble shippingCharge = 0.0.obs;
//
//   List<String> allDistrictNames = <String>[];
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController emailCodeController = TextEditingController();
//
//   @override
//   void onInit() async {
//     String upazilaData = await getDataFromFile("assets/json_data/upazila.json");
//     String districtData = await getDataFromFile(
//       "assets/json_data/district.json",
//     );
//
//     upazilaModel.value = upazilaModelFromJson(upazilaData);
//     districtModel.value = districtModelFromJson(districtData);
//     selectedDistrict.value = districtModel.value!.districts[13];
//     selectedDistrictWiseUpazila.value = upazilaModel.value!.upazilas
//         .where((element) => element.districtId == selectedDistrict.value!.id)
//         .toList();
//     selectedUpazila.value = upazilaModel.value!.upazilas[0];
//     fetchAllAddress();
//     super.onInit();
//   }
//
//   void searchUpazilaFromSelectedDistrictWiseUpazila({
//     required String searchKey,
//   }) {
//     searchAbleUpazila.value = selectedDistrictWiseUpazila
//         .where(
//           (element) =>
//               element.name.toLowerCase().contains(searchKey.toLowerCase()),
//         )
//         .toList();
//   }
//
//   void fetchAllAddress() async {
//     change(addressModel.value, status: RxStatus.loading());
//     try {
//       Response response = await AddressService.getAddressData();
//       addressModel.value = AddressModel.fromJson(response.data);
//       if (addressModel.value!.addressList!.isEmpty) {
//         change(addressModel.value, status: RxStatus.empty());
//       } else {
//         change(addressModel.value, status: RxStatus.success());
//       }
//     } catch (e) {
//       change(addressModel.value, status: RxStatus.error(e.toString()));
//     }
//   }
//
//   void addNewAddress() async {
//     change(addressModel.value, status: RxStatus.loading());
//     try {
//       AddAddressModel addAddressModel = AddAddressModel(
//         addressName: nameController.text,
//         phone: phoneController.text,
//         email: emailCodeController.text,
//         address: addressController.text,
//         postalCode: "0000",
//         district: selectedDistrict.value!.name,
//         thana: selectedUpazila.value!.name,
//         division: "Chittagong",
//         areaName: "Cumilla",
//       );
//       Response response = await AddressService.addAddressData(
//         address: addAddressModel,
//       );
//       addressModel.value = AddressModel.fromJson(response.data);
//       if (addressModel.value!.error!) {
//         BookStoreUtils.bookStoreSnackBar(
//           title: "Error",
//           message: "${addressModel.value!.message}",
//         );
//         change(addressModel.value, status: RxStatus.success());
//       } else {
//         change(addressModel.value, status: RxStatus.success());
//         clearAllTextFields();
//         resetDropDownValues();
//         Get.back();
//       }
//     } catch (e) {
//       change(addressModel.value, status: RxStatus.error(e.toString()));
//     }
//   }
//
//   void calculateShippingCharge({
//     required int cartId,
//     required int addressId,
//   }) async {
//     change(addressModel.value, status: RxStatus.loading());
//     try {
//       Response response = await AddressService.calculateShippingCharge(
//         cartId: cartId,
//         addressId: addressId,
//       );
//       ShippingCharge shippingChargeData = ShippingCharge.fromJson(
//         response.data,
//       );
//       shippingCharge.value = shippingChargeData.deliveryCharge!;
//       change(addressModel.value, status: RxStatus.success());
//     } catch (e) {
//       change(addressModel.value, status: RxStatus.error(e.toString()));
//     }
//   }
//
//   void deleteAddress({required int addressId}) async {
//     change(addressModel.value, status: RxStatus.loading());
//     try {
//       Response response = await AddressService.deleteAddress(
//         addressId: addressId,
//       );
//       addressModel.value = AddressModel.fromJson(response.data);
//       if (addressModel.value!.addressList!.isEmpty) {
//         change(addressModel.value, status: RxStatus.empty());
//       } else {
//         change(addressModel.value, status: RxStatus.success());
//       }
//     } catch (e) {
//       change(addressModel.value, status: RxStatus.error(e.toString()));
//     }
//   }
//
//   void updateAddress() async {
//     change(addressModel.value, status: RxStatus.loading());
//     try {
//       AddAddressModel addAddressModel = AddAddressModel(
//         addressName: nameController.text,
//         phone: phoneController.text,
//         email: emailCodeController.text,
//         address: addressController.text,
//         postalCode: "0000",
//         district: selectedDistrict.value!.name,
//         thana: selectedUpazila.value!.name,
//         division: "Chittagong",
//         areaName: "Cumilla",
//       );
//       Response response = await AddressService.updateAddressData(
//         address: addAddressModel,
//         addressId: updateAbleId.value,
//       );
//       addressModel.value = AddressModel.fromJson(response.data);
//       if (addressModel.value!.error!) {
//         BookStoreUtils.bookStoreSnackBar(
//           title: "Error",
//           message: "${addressModel.value!.message}",
//         );
//         change(addressModel.value, status: RxStatus.success());
//       } else {
//         change(addressModel.value, status: RxStatus.success());
//         clearAllTextFields();
//         resetDropDownValues();
//         isEditAddress.value = false;
//         Get.back();
//       }
//     } catch (e) {
//       change(addressModel.value, status: RxStatus.error(e.toString()));
//     }
//   }
//
//   void setAllTextFieldFromGivenAddress({required Address address}) {
//     updateAbleId.value = address.id ?? -1;
//     nameController.text = address.addressName ?? "";
//     phoneController.text = address.phone ?? "";
//     addressController.text = address.address ?? "";
//     emailCodeController.text = address.email ?? "";
//     selectedDistrict.value = districtModel.value!.districts.firstWhere(
//       (element) => element.name == address.district,
//     );
//     selectedDistrictWiseUpazila.value = upazilaModel.value!.upazilas
//         .where((element) => element.districtId == selectedDistrict.value!.id)
//         .toList();
//     selectedUpazila.value = selectedDistrictWiseUpazila.firstWhere(
//       (element) => element.name == address.thana,
//     );
//     isEditAddress.value = true;
//   }
//
//   void validateAndSubmitAddressForm() {
//     if (nameController.text == "") {
//       BookStoreUtils.bookStoreSnackBar(
//         title: "Alert",
//         message: "Name field is empty",
//       );
//     } else if (phoneController.text == "") {
//       BookStoreUtils.bookStoreSnackBar(
//         title: "Alert",
//         message: "Phone field is empty",
//       );
//     } else if (phoneController.text.length != 11 ||
//         !phoneController.text.startsWith("01")) {
//       BookStoreUtils.bookStoreSnackBar(
//         title: "Alert",
//         message: "Invalid phone number",
//       );
//     } else if (addressController.text == "") {
//       BookStoreUtils.bookStoreSnackBar(
//         title: "Alert",
//         message: "Address field is empty",
//       );
//     } else if (emailCodeController.text == "") {
//       BookStoreUtils.bookStoreSnackBar(
//         title: "Alert",
//         message: "Email code field is empty",
//       );
//     } else if (!isValidEmail(emailCodeController.text)) {
//       BookStoreUtils.bookStoreSnackBar(
//         title: "Alert",
//         message: "Email is not valid",
//       );
//     } else {
//       if (isEditAddress.value) {
//         updateAddress();
//         return;
//       } else {
//         addNewAddress();
//       }
//     }
//   }
//
//   Future<String> getDataFromFile(String filePath) async {
//     return await rootBundle.loadString(filePath);
//   }
//
//   bool isValidEmail(String email) {
//     final RegExp emailRegex = RegExp(
//       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
//     );
//
//     return emailRegex.hasMatch(email);
//   }
//
//   void clearAllTextFields() {
//     nameController.clear();
//     phoneController.clear();
//     addressController.clear();
//     emailCodeController.clear();
//   }
//
//   void resetDropDownValues() {
//     selectedDistrict.value = districtModel.value!.districts[13];
//     selectedDistrictWiseUpazila.value = upazilaModel.value!.upazilas
//         .where((element) => element.districtId == selectedDistrict.value!.id)
//         .toList();
//     selectedUpazila.value = selectedDistrictWiseUpazila[0];
//   }
// }
