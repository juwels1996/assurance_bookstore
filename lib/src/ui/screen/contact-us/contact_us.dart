import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Text(
              "We are happy to help you resolve your issues",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Contact Details
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildContactRow(Icons.phone, "Phone", "+8801716013899"),
                    _buildContactRow(
                      Icons.email,
                      "Email",
                      "email@companyname.com",
                    ),
                    _buildContactRow(
                      Icons.access_time,
                      "Mon to Fri",
                      "8 am - 5 pm",
                    ),
                    _buildContactRow(
                      Icons.access_time,
                      "Sat & Sun",
                      "10 am - 3 pm",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Response Time Info
            Column(
              children: [
                Icon(Icons.headset_mic, size: 50, color: Colors.redAccent),
                const SizedBox(height: 10),
                const Text(
                  "We respond to your queries within",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "24 Hours",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // CTA Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                Uri callBack = Uri.parse("https://www.facebook.com/livemcq");

                if (kIsWeb) {
                  launchUrl(callBack);
                } else {
                  if (Platform.isAndroid) {
                    try {
                      var canLaunchNatively = await canLaunchUrl(callBack);

                      if (canLaunchNatively) {
                        await launchUrl(
                          callBack,
                          mode: LaunchMode.externalNonBrowserApplication,
                        );
                      } else {
                        await launchUrl(
                          callBack,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    } catch (e) {
                      launchUrl(callBack);
                    }
                  } else if (Platform.isIOS) {
                    try {
                      var canLaunchNatively = await canLaunchUrl(callBack);

                      if (canLaunchNatively) {
                        await launchUrl(callBack);
                      } else {
                        await launchUrl(
                          callBack,
                          mode: LaunchMode.platformDefault,
                        );
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: "Not open URL");
                    }
                  }
                }
              },
              icon: const Icon(Icons.message, color: Colors.white),
              label: const Text(
                "Send Us a Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            child: Icon(icon, color: Colors.redAccent),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
