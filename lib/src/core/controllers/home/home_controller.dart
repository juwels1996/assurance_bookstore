import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../configuration/dioconfig.dart';
import '../../models/home/banner_model.dart';
import '../../models/home/home_page_data.dart';

class HomeController extends GetxController {
  final loadStatus = "Loading".obs;
  final errorMessage = "".obs;
  final isLoading = false.obs;
  final isError = false.obs;
  final isSuccess = false.obs;
  final isEmpty = false.obs;
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final isFirstLoad = true.obs;
  final isLastPage = false.obs;
  final isSearch = false.obs;
  final isFilter = false.obs;
  final homePageData = <HomePageData>[].obs;
  final banners = <BannerModel>[].obs;

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    loadStatus.value = "Loading";

    try {
      final response = await DioConfig().dio.get(
        'categories_with_subcategories_and_books/',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("book list -------------------------$data");

        if (data == null || data.isEmpty) {
          isEmpty.value = true;
          loadStatus.value = "No Data Available";
        } else {
          homePageData.value = homePageDataFromJson(jsonEncode(data));
          isEmpty.value = false;
          loadStatus.value = "Success";
          isSuccess.value = true;
          isError.value = false; // explicitly mark as not error
        }
      } else {
        errorMessage.value = "Failed to load data: ${response.statusMessage}";
        isError.value = true;
        loadStatus.value = "Error";
      }
    } catch (e) {
      errorMessage.value = "Exception: $e";
      isError.value = true;
      loadStatus.value = "Error";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBanners() async {
    try {
      final response = await DioConfig().dio.get('get_banners/');
      if (response.statusCode == 200) {
        final List data = response.data;
        banners.value = data
            .map((json) => BannerModel.fromJson(json))
            .where((b) => b.isActive)
            .toList();
      }
    } catch (e) {
      print("Error loading banners: $e");
    }
  }
}
