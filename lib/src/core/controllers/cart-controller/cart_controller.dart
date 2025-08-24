import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/book-details/book-details.dart';

import 'package:get/get.dart';

class CartItem<T> {
  T item;
  RxInt quantity;
  final bool isCombo;
  final List<Book>? comboBooks;

  CartItem({
    required this.item,
    int quantity = 1,
    this.isCombo = false,
    this.comboBooks,
  }) : quantity = quantity.obs;
}

class CartController extends GetxController {
  var cartItems = <CartItem<dynamic>>[].obs;
  String paymentMethod = 'bkash';

  /// Total items in cart
  int get totalItems =>
      cartItems.fold(0, (sum, cartItem) => sum + cartItem.quantity.value);

  /// Add single book
  void addToCart(dynamic newItem) {
    final index = cartItems.indexWhere((cartItem) {
      if (cartItem.isCombo) return false; // skip combos
      if (cartItem.item.runtimeType != newItem.runtimeType) return false;
      if (newItem is Book) return cartItem.item.id == newItem.id;
      if (newItem is BookDetail) return cartItem.item.id == newItem.id;
      return cartItem.item == newItem;
    });

    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(CartItem(item: newItem));
    }
  }

  /// Add combo (as one item)
  void addComboToCart(List<Book> books) {
    // Check if same combo already exists (compare book IDs)
    final index = cartItems.indexWhere(
      (cartItem) => cartItem.isCombo && _sameCombo(cartItem.comboBooks!, books),
    );

    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(
        CartItem(
          item: "Combo Pack",
          quantity: 1,
          isCombo: true,
          comboBooks: books,
        ),
      );
    }
  }

  /// Helper: check if two combos are the same
  bool _sameCombo(List<Book> a, List<Book> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toSet();
    final bIds = b.map((e) => e.id).toSet();
    return aIds.difference(bIds).isEmpty;
  }

  /// Remove item (works with both book + combo)
  void removeFromCart(dynamic targetItem) {
    final index = cartItems.indexWhere((cartItem) {
      if (cartItem.isCombo && targetItem is CartItem && targetItem.isCombo) {
        return _sameCombo(cartItem.comboBooks!, targetItem.comboBooks!);
      }
      if (cartItem.item.runtimeType != targetItem.runtimeType) return false;
      if (targetItem is Book) return cartItem.item.id == targetItem.id;
      if (targetItem is BookDetail) return cartItem.item.id == targetItem.id;
      return cartItem.item == targetItem;
    });

    if (index != -1) {
      if (cartItems[index].quantity.value > 1) {
        cartItems[index].quantity.value--;
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  /// Quantity for a specific item
  int getQuantity(dynamic targetItem) {
    final index = cartItems.indexWhere((cartItem) {
      if (cartItem.isCombo && targetItem is CartItem && targetItem.isCombo) {
        return _sameCombo(cartItem.comboBooks!, targetItem.comboBooks!);
      }
      if (cartItem.item.runtimeType != targetItem.runtimeType) return false;
      if (targetItem is Book) return cartItem.item.id == targetItem.id;
      if (targetItem is BookDetail) return cartItem.item.id == targetItem.id;
      return cartItem.item == targetItem;
    });
    return index != -1 ? cartItems[index].quantity.value : 0;
  }

  /// Clear cart
  void clearCart() => cartItems.clear();

  /// Total amount (supports combo)
  int get totalAmount => cartItems.fold(0, (sum, cartItem) {
    if (cartItem.isCombo) {
      // sum of all books in the combo
      final comboPrice = cartItem.comboBooks!.fold<int>(
        0,
        (sub, book) => sub + (book.discountedPrice ?? book.price),
      );
      return sum + comboPrice * cartItem.quantity.value;
    } else if (cartItem.item is Book) {
      final book = cartItem.item as Book;
      return sum +
          (book.discountedPrice ?? book.price) * cartItem.quantity.value;
    } else if (cartItem.item is BookDetail) {
      final book = cartItem.item as BookDetail;
      return sum +
          (book.discountedPrice ?? book.price)! * cartItem.quantity.value;
    }
    return sum;
  });

  /// Delivery charge (free if any combo)
  int get totalDeliveryCharge {
    if (cartItems.any((item) => item.isCombo)) return 0;

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
        if (totalItems == 1) {
          totalCharge += (deliveryCharge ?? 0) + 40;
        } else if (totalItems == 2) {
          totalCharge += (deliveryCharge ?? 0) + 40 + 40;
        } else if (totalItems > 2) {
          totalCharge += (deliveryCharge ?? 0) + 40 + (totalItems - 2) * 20;
        }
      } else {
        if (totalItems == 1) {
          totalCharge += (deliveryCharge ?? 0);
        } else if (totalItems == 2) {
          totalCharge += (deliveryCharge ?? 0) + 40;
        } else if (totalItems > 2) {
          totalCharge += (deliveryCharge ?? 0) + (totalItems - 2) * 20;
        }
      }
    }

    return totalCharge;
  }
}
