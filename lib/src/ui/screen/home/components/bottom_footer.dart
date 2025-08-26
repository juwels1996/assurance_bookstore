import 'package:flutter/material.dart';

import '../../../widgets/responsive.dart';

class BottomFooter extends StatelessWidget {
  const BottomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isLarge = Responsive.isLargeScreen(context);
    final isMedium = Responsive.isMediumScreen(context);

    return Container(
      height: 300,

      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(20),
      child: isLarge || isMedium
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildContactInfo(),
                _buildPageLinks(),
                _buildHelpLinks(),
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
            Text("+88 01313-770770"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.location_on, size: 18),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                "43 Shilpacharya Zainul Abedin Sarak (Old 16 Shantinagar), Dhaka - 1217",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.email, size: 18),
            SizedBox(width: 8),
            Text("support@pbs.com.bd"),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "Trade License :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text("TRAD/DSCC/233813/2019"),
      ],
    );
  }

  Widget _buildPageLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("PAGE", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("Home"),
        Text("Pre Order"),
        Text("Author"),
        Text("Publisher"),
        Text("Book Request"),
      ],
    );
  }

  Widget _buildHelpLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("HELP", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("Terms & Condition"),
        Text("Privacy Policy"),
        Text("Refund & Return Policy"),
        Text("About Us"),
        Text("Contact Us"),
      ],
    );
  }
}
