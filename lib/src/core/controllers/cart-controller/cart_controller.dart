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

    for (var item in cartItems) {
      final deliveryCharge = item.book.deliveryCharge ?? 0;
      totalCharge += deliveryCharge;

      // After the first book, apply additional charges based on quantity
      if (item.quantity.value > 1) {
        // If quantity is 2, apply 40 Tk per book
        if (item.quantity.value == 2) {
          totalCharge += 40;
        }
        // If quantity is more than 2, apply 20 Tk per additional book
        if (item.quantity.value > 2) {
          totalCharge += (item.quantity.value - 2) * 20;
        }
      }
    }

    return totalCharge;
  }
}
