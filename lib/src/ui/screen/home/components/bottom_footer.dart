import 'package:assurance_bookstore/src/ui/screen/cart-screen/cart_screen.dart';
import 'package:assurance_bookstore/src/ui/screen/contact-us/contact_us.dart';
import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
import 'package:assurance_bookstore/src/ui/screen/rules_regulation/about_us.dart';
import 'package:assurance_bookstore/src/ui/screen/rules_regulation/book_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/responsive.dart';
import '../../rules_regulation/privacy_policy.dart';
import '../../rules_regulation/refund_policy.dart';
import '../../rules_regulation/terms_condition.dart';

class BottomFooter extends StatelessWidget {
  const BottomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isLarge = Responsive.isLargeScreen(context);
    final isMedium = Responsive.isMediumScreen(context);

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(20),
      child: isLarge || isMedium
          ? Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildContactInfo(),
                    _buildPageLinks(),
                    _buildHelpLinks(),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactInfo(),
                const SizedBox(height: 20),
                _buildPageLinks(),
                const SizedBox(height: 20),
                _buildHelpLinks(),
              ],
            ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.phone, size: 18),
            SizedBox(width: 8),
            Column(
              children: [Text("+88 01341-875192"), Text("+88 01716013899")],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.location_on, size: 18),
            SizedBox(width: 8),
            Text("3, New Paltan Line (2nd Floor), Azimpur, Dhaka."),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.email, size: 18),
            SizedBox(width: 8),
            Text("assurance1996@gmail.com"),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "Trade License :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text("TRAD/DSCC/281943/2019"),
      ],
    );
  }

  Widget _buildPageLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PAGE", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Get.to(HomePage());
          },

          child: Text("Home"),
        ),
        GestureDetector(
          onTap: () {
            Get.to(CartScreen());
          },

          child: Text("Product cart"),
        ),
      ],
    );
  }

  Widget _buildHelpLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "HELP",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildLinkItem(
          Icons.article,
          "Terms & Condition",
          () => Get.to(() => const TermsAndConditionsScreen()),
        ),

        _buildLinkItem(
          Icons.money,
          "Book Order",
          () => Get.to(() => BookOrderPolicy()),
        ),

        _buildLinkItem(
          Icons.money,
          "About Us",
          () => Get.to(() => AboutUsScreen()),
        ),

        _buildLinkItem(
          Icons.privacy_tip,
          "Privacy Policy",
          () => Get.to(() => const AssurancePolicyScreen()),
        ),
        _buildLinkItem(
          Icons.assignment_return,
          "Refund & Return Policy",
          () => Get.to(() => const RefundPolicyScreen()),
        ),

        _buildLinkItem(
          Icons.contact_mail,
          "Contact Us",
          () => Get.to(() => ContactUsPage()),
        ),
      ],
    );
  }

  /// 🔗 Reusable Link Item with Icon
  Widget _buildLinkItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
