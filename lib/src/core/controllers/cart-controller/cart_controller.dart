import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/book-details/book-details.dart';

class CartItem {
  final BookDetail book;
  RxInt quantity;

  CartItem({required this.book, int quantity = 1}) : quantity = quantity.obs;
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  String paymentMethod = 'bkash';

  int get totalItems =>
      cartItems.fold(0, (sum, item) => sum + item.quantity.value);

  void addToCart(BookDetail book) {
    final index = cartItems.indexWhere((item) => item.book.id == book.id);
    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(CartItem(book: book));
    }
  }

  void removeFromCart(BookDetail book) {
    final index = cartItems.indexWhere((item) => item.book.id == book.id);
    if (index != -1) {
      if (cartItems[index].quantity.value > 1) {
        cartItems[index].quantity.value--;
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  int getQuantity(BookDetail book) {
    final index = cartItems.indexWhere((item) => item.book.id == book.id);
    if (index != -1) {
      return cartItems[index].quantity.value;
    }
    return 0;
  }

  void clearCart() {
    cartItems.clear();
  }

  int get totalAmount => cartItems.fold(0, (sum, item) {
    final price = item.book.discountedPrice ?? item.book.price ?? 0;
    return sum + (price * item.quantity.value);
  });

  int get totalPrice => cartItems.fold(0, (sum, item) {
    final price = item.book.discountedPrice ?? item.book.price ?? 0;
    return sum + (price * item.quantity.value);
  });

  int get totalDeliveryCharge {
    int totalCharge = 0;
    int totalBooks = cartItems.fold(
      0,
      (sum, item) => sum + item.quantity.value,
    );

    for (var item in cartItems) {
      final deliveryCharge = item.book.deliveryCharge ?? 0;

      // Logic for COD (Cash on Delivery)
      if (paymentMethod == 'cod') {
        if (totalBooks == 1) {
          // For the first book: Initial delivery charge from backend + 40
          totalCharge += deliveryCharge + 40;
        } else if (totalBooks == 2) {
          // For the second book: Initial delivery charge from backend + 40 for 1st book + 40 for 2nd book
          totalCharge += deliveryCharge + 40 + 40;
        } else if (totalBooks > 2) {
          // For more than 2 books: Initial delivery charge from backend + 40 for first two books + 20 for each additional book
          totalCharge += deliveryCharge + 40 + 40 + (totalBooks - 2) * 20;
        }
      }
      // Logic for other payment methods (bKash or regular)
      else {
        if (totalBooks == 1) {
          // For the first book: Only the delivery charge from backend
          totalCharge += deliveryCharge;
        } else if (totalBooks == 2) {
          // For the second book: Initial delivery charge from backend + 40
          totalCharge += deliveryCharge + 40;
        } else if (totalBooks > 2) {
          // For more than 2 books: Add 20 Taka for each additional book
          totalCharge += deliveryCharge + 40 + (totalBooks - 2) * 20;
        }
      }
    }

    return totalCharge;
  }
}
