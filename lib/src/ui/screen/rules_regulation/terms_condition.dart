import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("নীতিমালা"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "সর্বশেষ আপডেট: ১৩ জানুয়ারি ২০২৫",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "গোপনীয়তা নীতি:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "এখানে আপনার শর্তাবলী, নীতিমালা ও গোপনীয়তার বিবরণ থাকবে। "
                "আপনি চাইলে এটি একটি দীর্ঘ টেক্সট আকারে যোগ করতে পারেন এবং "
                "বুলেট লিস্ট বা হেডিং ব্যবহার করে আরও সুন্দরভাবে সাজাতে পারেন।",
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 20),

              Text(
                "আমরা যে তথ্য সংগ্রহ করি:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "• ব্যবহারকারীর নাম\n• ইমেইল ঠিকানা\n• ফোন নম্বর\n• প্রোফাইল সম্পর্কিত তথ্য",
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 20),

              Text(
                "তথ্য নিরাপত্তা:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "আমরা আপনার ব্যক্তিগত তথ্য নিরাপদ রাখতে সর্বোচ্চ চেষ্টা করি, তবে ইন্টারনেটে ১০০% নিরাপত্তা নিশ্চিত করা সম্ভব নয়।",
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("আমি সম্মত"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
