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

  fetchHomeData() {
    loadStatus.value = "Loading";
    try {
      final response = DioConfig().dio.get(
        'categories_with_subcategories_and_books/',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data.isEmpty) {
          isEmpty.value = true;
          loadStatus.value = "No Data Available";
        } else {
          isEmpty.value = false;
          // Process the data as needed
          loadStatus.value = "Success";
          isSuccess.value = true;
        }
      } else {
        errorMessage.value = "Failed to load data: ${response.statusMessage}";
        isError.value = true;
        loadStatus.value = "Error";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isError.value = true;
      loadStatus.value = "Error";
    } finally {
      isLoading.value = false;
    }
  }
}
