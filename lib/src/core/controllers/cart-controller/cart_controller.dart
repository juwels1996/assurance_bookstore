import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/book-details/book-details.dart';

class CartItem<T> {
  T item; // Can be either Book or BookDetail
  RxInt quantity;

  CartItem({required this.item, int quantity = 1}) : quantity = quantity.obs;
}

class CartController extends GetxController {
  var cartItems = <CartItem<dynamic>>[].obs; // Can handle any object type

  String paymentMethod = 'bkash';

  // Total items in cart
  int get totalItems =>
      cartItems.fold(0, (sum, item) => sum + item.quantity.value);

  // Add an item to the cart (works with any model type)
  void addToCart(dynamic item) {
    final index = cartItems.indexWhere((cartItem) => cartItem.item == item);
    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(CartItem(item: item));
    }
  }

  // Remove an item from the cart
  void removeFromCart(dynamic item) {
    final index = cartItems.indexWhere((cartItem) => cartItem.item == item);
    if (index != -1) {
      if (cartItems[index].quantity.value > 1) {
        cartItems[index].quantity.value--;
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  // Get quantity for a specific item (works with any model type)
  int getQuantity(dynamic item) {
    final index = cartItems.indexWhere((cartItem) => cartItem.item == item);
    if (index != -1) {
      return cartItems[index].quantity.value;
    }
    return 0;
  }

  // Clear all items in the cart
  void clearCart() {
    cartItems.clear();
  }

  // Total amount of all items (works with any model type)
  int get totalAmount => cartItems.fold(0, (sum, item) {
    final price = item.item is Book
        ? (item.item as Book).discountedPrice ?? (item.item as Book).price
        : (item.item as BookDetail).discountedPrice ??
              (item.item as BookDetail).price;
    return sum + (price! * item.quantity.value);
  });

  // Total delivery charge (works with any model type)
  int get totalDeliveryCharge {
    int totalCharge = 0;
    int totalItems = cartItems.fold(
      0,
      (sum, item) => sum + item.quantity.value,
    );

    for (var item in cartItems) {
      final deliveryCharge = item.item is Book
          ? (item.item as Book).deliveryCharge
          : (item.item as BookDetail).deliveryCharge;

      if (paymentMethod == 'cod') {
        if (totalItems == 1)
          totalCharge += (deliveryCharge! + 40)!;
        else if (totalItems == 2)
          totalCharge += deliveryCharge! + 40 + 40;
        else if (totalItems > 2)
          totalCharge += deliveryCharge! + 40 + 40 + (totalItems - 2) * 20;
      } else {
        if (totalItems == 1)
          totalCharge += deliveryCharge!;
        else if (totalItems == 2)
          totalCharge += (deliveryCharge! + 40)!;
        else if (totalItems > 2)
          totalCharge += deliveryCharge! + 40 + (totalItems - 2) * 20;
      }
    }

    return totalCharge;
  }
}
