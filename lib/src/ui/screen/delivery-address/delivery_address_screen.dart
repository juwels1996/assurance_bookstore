import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';

class DeliveryAddressScreen extends StatefulWidget {
  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
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

  bool isHome = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Address")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery Address",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ToggleButtons(
              isSelected: [isHome, !isHome],
              onPressed: (index) => setState(() => isHome = index == 0),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [Icon(Icons.home), Text(" Home")]),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [Icon(Icons.apartment), Text(" Office")],
                  ),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.green,
            ),
            const SizedBox(height: 20),

            _buildRowFields(
              "Your Name",
              nameController,
              Icons.person,
              "Mobile No",
              phoneController,
              Icons.phone,
            ),
            _buildRowFields(
              "Flat No./Floor",
              flatController,
              Icons.domain,
              "House No. & Name",
              houseController,
              Icons.home_work,
            ),
            _buildField(
              "Street Address (Road No, Area, Union)",
              addressController,
              icon: Icons.location_on,
              maxLines: 2,
            ),
            _buildRowFields(
              "Post Code",
              postCodeController,
              Icons.pin,
              "Alternate Mobile No",
              altPhoneController,
              Icons.phone_android,
            ),
            _buildRowFields(
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal"),
                      Text("${cartController.totalPrice} Tk"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("VAT"), Text("0 Tk")],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery Charge"),
                      Text("${cartController.totalDeliveryCharge} Tk"),
                    ],
                  ),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Payable Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${cartController.totalAmount + cartController.totalDeliveryCharge} Tk",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                final data = {
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
                checkoutController.submitDeliveryInfo(data);
              },
              icon: const Icon(Icons.check_circle_outline),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              label: const Text("Save Address and Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildRowFields(
    String label1,
    TextEditingController ctrl1,
    IconData icon1,
    String label2,
    TextEditingController ctrl2,
    IconData icon2,
  ) {
    return Row(
      children: [
        Expanded(child: _buildField(label1, ctrl1, icon: icon1)),
        const SizedBox(width: 12),
        Expanded(child: _buildField(label2, ctrl2, icon: icon2)),
      ],
    );
  }
}
