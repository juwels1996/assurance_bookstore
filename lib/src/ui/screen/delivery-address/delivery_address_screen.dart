import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';
import '../../../core/models/book-details/book-details.dart';
import '../../../core/models/district_model.dart';
import '../../../core/models/districts.dart';
import '../../../core/models/upazilla.dart';
import '../../../core/models/upzila_model.dart';
import '../bkash-payment/bkash_payment_screen.dart';
import '../invoice_Screen.dart';
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
  var selectedDistrictId = "1";
  var selectedUpazillaId = "1"; // ID of selected upazilla
  List<Map<String, String>> availableUpazillas = [];

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
  bool isEditing = false;
  Map<String, dynamic>? _initialAddress;

  @override
  void initState() {
    super.initState();
    updateUpazillaList(selectedDistrictId);
    fetchSavedAddress();
  }

  void updateUpazillaList(String districtId) {
    setState(() {
      availableUpazillas = districtsData["upazilas"]
          .where((upazila) => upazila['district_id'] == districtId)
          .toList();

      selectedUpazillaId = availableUpazillas[0]["id"] ?? "";
    });
  }

  void fetchSavedAddress() async {
    final response = await checkoutController.getSavedAddress();
    if (response != null) {
      setState(() {
        isAddressSaved = true;
        isEditing = false;
        savedAddress =
            "${response['flat']} ${response['phone']}, ${response['street']}, ${response['district']}, ${response['thana']}, Bangladesh";

        nameController.text = response['name'] ?? '';
        phoneController.text = response['phone'] ?? '';
        flatController.text = response['flat'] ?? '';
        houseController.text = response['house'] ?? '';
        addressController.text = response['street'] ?? '';
        postCodeController.text = response['post_code'] ?? '';
        altPhoneController.text = response['alternate_phone'] ?? '';
        districtController.text = response['district'] ?? '';
        thanaController.text = response['thana'] ?? '';
        noteController.text = response['special_instruction'] ?? '';
        _initialAddress = Map<String, dynamic>.from(response);
      });
    }
  }

  int? _extractBookId(dynamic x) {
    if (x == null) return null;

    // Known models
    try {
      if (x is Book) return x.id;
      if (x is BookDetail) return x.id;
    } catch (_) {
      /* ignore */
    }

    // Map-like: {'id': 123}
    if (x is Map) {
      final v = x['id'];
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
    }

    // String fallback (avoid .id on "Combo Pack")
    // If your string sometimes contains numbers like "123 - Combo Pack"
    if (x is String) {
      final m = RegExp(r'\d+').firstMatch(x);
      if (m != null) return int.tryParse(m.group(0)!);
      return null; // plain title -> no id
    }

    return null;
  }

  List<Map<String, dynamic>> _buildCartItems() {
    final cart = <Map<String, dynamic>>[];

    for (final e in Get.find<CartController>().cartItems) {
      final qty = (e.quantity.value ?? e.quantity ?? 1);

      // Combo line
      if (e.isCombo == true) {
        final books = e.comboBooks ?? [];

        for (final b in books) {
          final id = _extractBookId(b);
          if (id != null) {
            cart.add({'book_id': id, 'quantity': qty});
          }
        }

        if (books.isNotEmpty && !cart.any((m) => m.containsKey('book_id'))) {
          Get.snackbar(
            'Cart error',
            'This combo has no book IDs. Please re-add the combo.',
          );
          return <Map<String, dynamic>>[];
        }

        continue;
      }

      // Single item
      final id = _extractBookId(e.item);
      if (id != null) {
        cart.add({'book_id': id, 'quantity': qty});
      } else {
        debugPrint('Skipped cart item without id: $e');
      }
    }

    // Removed the API and navigation logic from here.
    // It just returns the cart now.
    return cart;
  }

  Future<void> generateAndShowPdf() async {
    final pdf = pw.Document();

    // Load your custom fonts from assets
    final banglaFontData = await rootBundle.load("assets/fonts/kalpurush.ttf");
    final banglaFont = pw.Font.ttf(banglaFontData);

    final englishFontData = await rootBundle.load("assets/fonts/notoserif.ttf");
    final englishFont = pw.Font.ttf(englishFontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // --- Success Header ---
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "Thank You for Your Order!",
                      style: pw.TextStyle(
                        fontSize: 22,
                        color: PdfColors.green700,
                        font: englishFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "আপনার অর্ডারটি সফলভাবে সম্পন্ন হয়েছে।",
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                        font: banglaFont,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 25),

              // --- Order Summary Box (Two Column Design) ---
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Text(
                        "Order Summary (অর্ডার বিবরণ)",
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: banglaFont,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Divider(color: PdfColors.grey300, height: 1),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(16),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Left Column: Customer Data
                          pw.Expanded(
                            child: pw.Column(
                              children: [
                                _buildSummaryRow(
                                  "Name:",
                                  nameController.text,
                                  banglaFont,
                                ),
                                _buildSummaryRow(
                                  "Phone:",
                                  phoneController.text,
                                  banglaFont,
                                ),
                                _buildSummaryRow(
                                  "Address:",
                                  addressController.text,
                                  banglaFont,
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 20),
                          // Right Column: Order Data
                          pw.Expanded(
                            child: pw.Column(
                              children: [
                                _buildSummaryRow(
                                  "Status:",
                                  "Pending",
                                  banglaFont,
                                ),
                                _buildSummaryRow(
                                  "Total:",
                                  "৳${cartController.totalAmount + cartController.totalDeliveryCharge}",
                                  banglaFont,
                                ),
                                _buildSummaryRow(
                                  "Payment:",
                                  widget.paymentMethod == 'cod'
                                      ? "Cash on Delivery"
                                      : "bKash",
                                  banglaFont,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- Itemized Table ---
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "অর্ডারকৃত বইসমূহ:",
                  style: pw.TextStyle(
                    font: banglaFont,
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // Simplified Table for Items
              ...cartController.cartItems.map((item) {
                String bookTitle =
                    item.isCombo ? "Combo Pack" : (item.item.title ?? "Book");
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          bookTitle,
                          style: pw.TextStyle(font: banglaFont, fontSize: 11),
                        ),
                      ),
                      pw.Text(
                        "Qty: ${item.quantity.value}",
                        style: pw.TextStyle(font: banglaFont, fontSize: 11),
                      ),
                    ],
                  ),
                );
              }).toList(),

              pw.Divider(color: PdfColors.grey300),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "সর্বমোট: ৳${cartController.totalAmount + cartController.totalDeliveryCharge}",
                  style: pw.TextStyle(
                    font: banglaFont,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Reusable Summary Row Helper
  pw.Widget _buildSummaryRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 60,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                font: font,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                font: font,
                fontSize: 10,
                color: PdfColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Helper widget for the grid rows
  // pw.Widget _buildSummaryRow(
  //   String label,
  //   String value,
  //   pw.Font font,
  //   pw.Font bold,
  // ) {
  //   return pw.Padding(
  //     padding: const pw.EdgeInsets.symmetric(vertical: 6),
  //     child: pw.Row(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.SizedBox(
  //           width: 100,
  //           child: pw.Text(
  //             label,
  //             style: pw.TextStyle(font: bold, fontSize: 10),
  //           ),
  //         ),
  //         pw.Expanded(
  //           child: pw.Text(
  //             value,
  //             style: pw.TextStyle(
  //               font: font,
  //               fontSize: 10,
  //               color: PdfColors.grey900,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _submitOrder(
  //   List<Map<String, dynamic>> cart,
  //   String deliveryType,
  // ) async {
  //   // 1. Submit the order to the backend
  //   final order = await checkoutController.submitOrder(
  //     cart,
  //     deliveryType: deliveryType,
  //   );
  //
  //   if (order != null) {
  //     // 2. Clear the cart immediately so it's empty for the next purchase
  //     Get.find<CartController>().clearCart();
  //
  //     // 3. If it's COD, generate and show the PDF.
  //     // The 'await' makes sure it stays here until the user closes the PDF screen.
  //     if (deliveryType == 'cod') {
  //       await generateAndShowPdf();
  //     }
  //
  //     // 4. Show the success message
  //     Get.snackbar(
  //       'Order Success',
  //       'Order #${order['order_id']} submitted successfully',
  //     );
  //
  //     // 5. Send them back to the Home Screen
  //     Get.offAll(() => HomePage());
  //   }
  // }

  void _submitOrder(
    List<Map<String, dynamic>> cart,
    String deliveryType,
  ) async {
    // 1. Submit the order to the backend
    final order = await checkoutController.submitOrder(
      cart,
      deliveryType: deliveryType,
    );

    if (order != null) {
      print("order is okkk");

      // if (deliveryType == 'cod') {
      //   await generateAndShowPdf();
      // }

      Get.find<CartController>().clearCart();

      // 4. Show the success message
      // Get.snackbar(
      //   'Order Success',
      //   'Order #${order['order_id']} submitted successfully',
      // );

      // 5. Send them to Order Success Screen
      Get.offAll(() => OrderSuccessScreen(
            orderId: order['order_id'],
            amount: (order['amount'] ?? 0).toDouble(),
            orderData: order,
          ));
    }
  }

  void _navigateToPaymentScreen(
    List<Map<String, dynamic>> cart,
    String deliveryType,
  ) async {
    Get.to(() => PaymentScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Address"),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isAddressSaved && !isEditing)
              _buildSavedAddressSection()
            else
              _buildAddressForm(),
            const SizedBox(height: 20),
            _buildOrderSummaryBkash(),
            const SizedBox(height: 20),
            Text("Selected Payment Method: ${widget.paymentMethod}"),
            if (widget.paymentMethod == 'cod')
              const Text(
                "Cash on Delivery selected. Pay delivery charge now.",
              )
            else
              const Text("bKash selected. User will pay full amount via bKash."),
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 1. Build cart
                      final cartData = _buildCartItems();
                      if (cartData.isEmpty) return;

                      // 2. Route based on payment method
                      // if (widget.paymentMethod == 'cod') {
                      //   _submitOrder(cartData, widget.paymentMethod);
                      // } else {
                      _navigateToPaymentScreen(cartData, widget.paymentMethod);
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Use Current Address",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => isEditing = true),
                    child: const Text("Add New Address",
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
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

            _buildField(
              "Street Address (Road No, Area, Union)",
              addressController,
              icon: Icons.location_on,
              maxLines: 2,
            ),

            // buildRowFields(
            //   "Post Code",
            //   postCodeController,
            //   Icons.pin,
            //   "Alternate Mobile No",
            //   altPhoneController,
            //   Icons.phone_android,
            // ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: _buildDistrictDropDownField("District"),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(child: _buildUpazillaDropDownField("Upazilla")),
            //   ],
            // ),
            SizedBox(height: 6.h),

            // 🔻 REPLACED old static “District/Thana” row with dynamic dropdowns
            // _buildField(
            //   "Special Instruction (Optional)",
            //   noteController,
            //   icon: Icons.notes,
            //   maxLines: 3,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryBkash() {
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
            _buildSummaryRowBkash(
              "Subtotal",
              "${cartController.totalAmount} Tk",
            ),
            _buildSummaryRowBkash("VAT", "0 Tk"),
            _buildSummaryRowBkash(
              "Delivery Charge",
              "${cartController.totalDeliveryCharge} Tk",
            ),
            const Divider(),
            _buildSummaryRowBkash(
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

  Widget _buildSummaryRowBkash(
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
    // If it is 'cod', it's Cash on Delivery. Otherwise, it is bKash or Home Delivery prepay.
    final isCod = widget.paymentMethod == 'cod';
    final btnText =
        isCod ? "Confirm & Pay Delivery Charge" : "Continue to bKash";

    return ElevatedButton.icon(
      onPressed: () async {
        print("tapppp print----------");

        // 1. Save Address info
        final addressData = {
          'name': nameController.text,
          'phone': phoneController.text,
          'street': addressController.text,
        };

        if (!isAddressSaved || isEditing) {
          final ok = await checkoutController.submitDeliveryInfo(addressData);
          if (!ok) return;

          setState(() {
            isAddressSaved = true;
            isEditing = false;
            savedAddress =
                "${addressController.text} ${phoneController.text}, ${districtController.text}, ${thanaController.text}, Bangladesh";
          });
        }

        // 2. Build Cart Items
        final cartData = _buildCartItems();
        if (cartData.isEmpty) {
          Get.snackbar("Error", "Your cart is empty or invalid.");
          return;
        }

        // 3. Go to payment screen
        _navigateToPaymentScreen(cartData, widget.paymentMethod);
      },
      icon: Image.asset("assets/images/bkash.png", height: 25.h, width: 30.w),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink, // bKash color
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      label: Text(
        btnText,
        style: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDistrictDropDownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // Border color
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          child: DropdownButton2<String>(
            autofocus: false,
            isDense: false,
            dropdownStyleData: DropdownStyleData(
              elevation: 0,
              offset: Offset.zero,
            ),
            value: selectedDistrictId, // Use string value for comparison
            hint: Text("Select $label"),
            isExpanded: true, // Make the dropdown occupy the full width
            onChanged: (newValue) {
              setState(() {
                selectedDistrictId = newValue!;
                updateUpazillaList(newValue);
                districtController.text = districtsData["districts"].firstWhere(
                  (e) => e["id"] == selectedDistrictId,
                )["name"];
              });
            },
            items: districtsData["districts"].map<DropdownMenuItem<String>>((
              district,
            ) {
              return DropdownMenuItem<String>(
                value: district["id"], // Set district id as value
                child: Text(district["name"]), // Display district name
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUpazillaDropDownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // Border color
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          child: DropdownButton<String>(
            value: selectedUpazillaId, // Use string value for comparison
            hint: Text("Select $label"),
            onChanged: (newValue) {
              setState(() {
                selectedUpazillaId = newValue!;
                thanaController.text = districtsData["upazilas"].firstWhere(
                  (e) => e["id"] == selectedUpazillaId,
                )["name"];
              });
            },
            items: availableUpazillas.map<DropdownMenuItem<String>>((upazilla) {
              return DropdownMenuItem<String>(
                value: upazilla["id"], // Set upazilla id as value
                child: Text(upazilla["name"]!), // Display upazilla name
              );
            }).toList(),
          ),
        ),
      ],
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

  Future<String> getDataFromFile(String filePath) async {
    return await rootBundle.loadString(filePath);
  }
}
