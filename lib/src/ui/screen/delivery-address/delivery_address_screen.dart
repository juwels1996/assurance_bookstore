import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/controllers/checkout-controller/checkout_controller.dart';

class DeliveryAddressScreen extends StatefulWidget {
  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();
  final altPhoneController = TextEditingController();
  final districtController = TextEditingController();
  final thanaController = TextEditingController();
  final noteController = TextEditingController();

  final checkoutController = Get.find<CheckoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Address")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField("Your Name", nameController),
            _buildField("Mobile No", phoneController),
            _buildField("Street Address", addressController),
            _buildField("Post Code", postCodeController),
            _buildField("Alternate Phone", altPhoneController),
            _buildField("District", districtController),
            _buildField("Thana", thanaController),
            _buildField(
              "Special Instruction (Optional)",
              noteController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final data = {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'street': addressController.text,
                  'post_code': postCodeController.text,
                  'alternate_phone': altPhoneController.text,
                  'district': districtController.text,
                  'thana': thanaController.text,
                  'special_instruction': noteController.text,
                };

                print("auth-------------$data");

                checkoutController.submitDeliveryInfo(data);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save Address and Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
