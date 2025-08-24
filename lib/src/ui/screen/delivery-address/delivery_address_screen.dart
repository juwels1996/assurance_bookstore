import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';
import '../../../core/models/book-details/book-details.dart';
import '../bkash-payment/bkash_payment_screen.dart';
import 'order_success_screen.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final String paymentMethod;

  const DeliveryAddressScreen({super.key, required this.paymentMethod});
  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final checkoutController = Get.find<CheckoutController>();
  final cartController = Get.find<CartController>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final flatController = TextEditingController();
  final houseController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();
  final altPhoneController = TextEditingController();
  final districtController = TextEditingController();
  final thanaController = TextEditingController();
  final noteController = TextEditingController();

  String savedAddress = "";
  bool isAddressSaved = false;

  @override
  void initState() {
    super.initState();
    fetchSavedAddress();
  }

  void fetchSavedAddress() async {
    final response = await checkoutController.getSavedAddress();
    if (response != null) {
      setState(() {
        isAddressSaved = true;
        savedAddress =
            "${response['flat']} ${response['phone']}, ${response['street']}, ${response['district']}, ${response['thana']}, Bangladesh";

        nameController.text = response['name'];
        phoneController.text = response['phone'];
        flatController.text = response['flat'];
        houseController.text = response['house'];
        addressController.text = response['street'];
        postCodeController.text = response['post_code'];
        altPhoneController.text = response['alternate_phone'];
        districtController.text = response['district'];
        thanaController.text = response['thana'];
        noteController.text = response['special_instruction'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Address"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isAddressSaved)
              _buildSavedAddressSection()
            else
              _buildAddressForm(),
            const SizedBox(height: 20),
            _buildOrderSummary(),
            const SizedBox(height: 20),

            Text("Selected Payment Method: ${widget.paymentMethod}"),

            if (widget.paymentMethod == 'cod')
              Text("Cash on Delivery selected. Special delivery logic applied.")
            else
              Text("bKash selected. User will pay via bKash."),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedAddressSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Saved Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              savedAddress,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isAddressSaved = false;
                  savedAddress = "";
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Add New Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildRowFields(
              "Your Name",
              nameController,
              Icons.person,
              "Mobile No",
              phoneController,
              Icons.phone,
            ),
            // buildRowFields(
            //   "Flat No./Floor",
            //   flatController,
            //   Icons.domain,
            //   "House No. & Name",
            //   houseController,
            //   Icons.home_work,
            // ),
            _buildField(
              "Street Address (Road No, Area, Union)",
              addressController,
              icon: Icons.location_on,
              maxLines: 2,
            ),
            buildRowFields(
              "Post Code",
              postCodeController,
              Icons.pin,
              "Alternate Mobile No",
              altPhoneController,
              Icons.phone_android,
            ),
            buildRowFields(
              "District",
              districtController,
              Icons.map,
              "Thana",
              thanaController,
              Icons.location_city,
            ),
            _buildField(
              "Special Instruction (Optional)",
              noteController,
              icon: Icons.notes,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildSummaryRow("Subtotal", "${cartController.totalAmount} Tk"),
            _buildSummaryRow("VAT", "0 Tk"),
            _buildSummaryRow(
              "Delivery Charge",
              "${cartController.totalDeliveryCharge} Tk",
            ),
            const Divider(),
            _buildSummaryRow(
              "Total Payable Amount",
              "${cartController.totalAmount + cartController.totalDeliveryCharge} Tk",
              isBold: true,
              valueColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final addressData = {
          'name': nameController.text,
          'phone': phoneController.text,
          'flat': flatController.text,
          'house': houseController.text,
          'street': addressController.text,
          'post_code': postCodeController.text,
          'alternate_phone': altPhoneController.text,
          'district': districtController.text,
          'thana': thanaController.text,
          'special_instruction': noteController.text,
        };

        final savedAddress = await checkoutController.getSavedAddress();

        print("-----------------------------orsder");

        if (savedAddress == null) {
          await checkoutController.submitDeliveryInfo(addressData);
        }

        final cartItems = Get.find<CartController>().cartItems
            .map((e) {
              if (e.item is Book) {
                return {
                  'book_id': (e.item as Book).id,
                  'quantity': e.quantity.value,
                };
              } else if (e.item is BookDetail) {
                return {
                  'book_id': (e.item as BookDetail).id,
                  'quantity': e.quantity.value,
                };
              } else if (e.item is String && e.isCombo) {
                // combo as string
                return {
                  'book_id': e.item, // or you may need e.itemId if you have it
                  'quantity': e.quantity.value,
                };
              } else if (e.item is Book) {
                return {
                  'book_id': (e.item as Book).id,
                  'quantity': e.quantity.value,
                };
              } else {
                return null; // skip unknown items
              }
            })
            .where((e) => e != null)
            .cast<Map<String, dynamic>>()
            .toList();

        print("-----------------------------order2");

        if (widget.paymentMethod == 'cod') {
          final order = await checkoutController.submitOrder(
            cartItems.cast<Map<String, dynamic>>(),
          );

          print("---------------${cartItems}");
          if (order != null) {
            Get.snackbar(
              'Order Success',
              'Order #${order['order_id']} submitted successfully',
            );
            Get.offAll(
              () =>
                  OrderSuccessScreen(orderId: order['order_id'], orderData: {}),
            );
          }
        } else {
          final result = await Get.to(() => PaymentScreen());

          if (result == true) {
            final order = await checkoutController.submitOrder(
              cartItems.cast<Map<String, dynamic>>(),
            );
            if (order != null) {
              Get.snackbar(
                'Order Success',
                'Order #${order['order_id']} submitted successfully',
              );
              Get.offAll(
                () => OrderSuccessScreen(
                  orderId: order['order_id'],
                  orderData: {},
                ),
              );
            }
          }
        }
      },
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      label: const Text(
        "Order Place-------",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
  }) {
    if (label == "District" || label == "Thana") {
      final List<String> items = label == "District"
          ? ["Dhaka", "Chittagong", "Khulna", "Rajshahi", "Kishoreganj"]
          : ["Mirpur", "Gulshan", "Banani", "Dhanmondi"];

      // only use controller.text if it matches one of the items
      String? dropdownValue = items.contains(controller.text)
          ? controller.text
          : null;

      return DropdownButtonFormField<String>(
        value: dropdownValue, // ✅ safe assignment
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          controller.text = value ?? "";
        },
      );
    }

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }

  Widget buildRowFields(
    String label1,
    TextEditingController ctrl1,
    IconData icon1,
    String label2,
    TextEditingController ctrl2,
    IconData icon2,
  ) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildField(label1, ctrl1, icon: icon1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildField(label2, ctrl2, icon: icon2)),
      ],
    );
  }
}
