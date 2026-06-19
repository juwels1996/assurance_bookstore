import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
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
  final RxList<Book> books = <Book>[].obs;

  final _storage = GetStorage();
  DateTime? _lastFetchTime;

  Future<void> fetchHomeData() async {
    // Show cached data instantly if available
    if (homePageData.isEmpty) {
      final cached = _storage.read('home_data');
      if (cached != null) {
        try {
          homePageData.value = homePageDataFromJson(cached);
          isEmpty.value = false;
          isSuccess.value = true;
        } catch (_) {}
      }
    }

    // Skip network call if data was fetched less than 5 minutes ago
    if (_lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inMinutes < 5 &&
        homePageData.isNotEmpty) {
      return;
    }

    isLoading.value = homePageData.isEmpty;
    loadStatus.value = "Loading";

    try {
      final response = await DioConfig().dio.get(
            'categories_with_subcategories_and_books/',
          );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null || data.isEmpty) {
          isEmpty.value = true;
          loadStatus.value = "No Data Available";
        } else {
          final encoded = jsonEncode(data);
          homePageData.value = homePageDataFromJson(encoded);
          _storage.write('home_data', encoded);
          _lastFetchTime = DateTime.now();
          isEmpty.value = false;
          loadStatus.value = "Success";
          isSuccess.value = true;
          isError.value = false;
        }
      } else {
        errorMessage.value = "Failed to load data: ${response.statusMessage}";
        isError.value = homePageData.isEmpty;
        loadStatus.value = "Error";
      }
    } catch (e) {
      errorMessage.value = "Exception: $e";
      isError.value = homePageData.isEmpty;
      loadStatus.value = "Error";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchBooks(String query) async {
    isLoading.value = true;

    try {
      final response = await DioConfig().dio.get('search_books/?query=$query');

      if (response.statusCode == 200) {
        final data = response.data;
        books.value = List<Book>.from(
          data.map((bookData) => Book.fromJson(bookData)),
        );

        isLoading.value = false;
      } else {
        isError.value = true;
        errorMessage.value = "Error: ${response.statusMessage}";
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = "Exception: $e";
      isLoading.value = false;
    }
  }

  Future<void> loadBanners() async {
    // Show cached banners instantly
    if (banners.isEmpty) {
      final cached = _storage.read('banners_data');
      if (cached != null) {
        try {
          final List data = jsonDecode(cached);
          banners.value = data
              .map((json) => BannerModel.fromJson(json))
              .where((b) => b.isActive)
              .toList();
        } catch (_) {}
      }
    }

    try {
      final response = await DioConfig().dio.get('get_banners/');
      if (response.statusCode == 200) {
        final List data = response.data;
        banners.value = data
            .map((json) => BannerModel.fromJson(json))
            .where((b) => b.isActive)
            .toList();
        _storage.write('banners_data', jsonEncode(data));
      }
    } catch (e) {
      print("Error loading banners: $e");
    }
  }
}
