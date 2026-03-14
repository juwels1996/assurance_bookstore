// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// Future<void> generateAndShowPdf() async {
//   final pdf = pw.Document();
//
//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Header(level: 0, text: "Order Summary - Assurance Bookstore"),
//             pw.SizedBox(height: 20),
//             pw.Text("Customer Name: ${nameController.text}"),
//             pw.Text("Phone: ${phoneController.text}"),
//             pw.Text("Address: ${addressController.text}"),
//             pw.Divider(),
//             pw.Text(
//               "Ordered Items:",
//               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 10),
//
//             // Loop through cart items
//             ...cartController.cartItems.map((item) {
//               String name = item.isCombo
//                   ? "Combo Pack"
//                   : (item.item.title ?? "Book");
//               return pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [pw.Text("$name x ${item.quantity.value}")],
//               );
//             }).toList(),
//
//             pw.Divider(),
//             pw.Align(
//               alignment: pw.Alignment.centerRight,
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.end,
//                 children: [
//                   pw.Text("Subtotal: ${cartController.totalAmount} Tk"),
//                   pw.Text(
//                     "Delivery Charge: ${cartController.totalDeliveryCharge} Tk",
//                   ),
//                   pw.Text(
//                     "Total: ${cartController.totalAmount + cartController.totalDeliveryCharge} Tk",
//                     style: pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 40),
//             pw.Center(child: pw.Text("Thank you for your order!")),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Show the PDF Preview
//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }
