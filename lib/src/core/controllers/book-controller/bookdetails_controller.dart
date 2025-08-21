import 'package:assurance_bookstore/src/core/models/book-details/book-details.dart';
import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:get/get.dart';
import '../../configuration/dioconfig.dart';

class BookDetailsController extends GetxController {
  final loadStatus = "Loading".obs;
  final errorMessage = "".obs;
  final isLoading = false.obs;
  final isError = false.obs;
  final isSuccess = false.obs;
  final isEmpty = false.obs;

  final bookDetails =
      Rxn<BookDetail>(); // Safe nullable observable for BookDetail

  Future<void> fetchBookDetailsData(String bookId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await DioConfig().dio.get('book/$bookId/');

      if (response.statusCode == 200 && response.data != null) {
        bookDetails.value = BookDetail.fromJson(response.data);
      } else {
        errorMessage.value = 'Failed to load book details.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
