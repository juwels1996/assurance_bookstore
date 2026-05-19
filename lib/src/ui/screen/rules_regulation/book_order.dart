import 'package:flutter/material.dart';

class BookOrderPolicy extends StatelessWidget {
  const BookOrderPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📦 Order Process & Courier Charge"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Intro paragraph
            const Text(
              "Assurance Publications -এর নিজস্ব ওয়েবসাইট থেকে পাঠকরা সরাসরি প্রকাশকের কাছ থেকে আসল মূল্যে বই ক্রয়ের সুযোগ পাচ্ছেন।\n\n"
              "আমরা প্রতিশ্রুতিবদ্ধ, পাঠকের কাঙ্ক্ষিত বই দ্রুততম সময়ে ও সঠিক মূল্যে পৌঁছে দেওয়ার জন্য। "
              "সাধারণত ডেলিভারী চার্জ নির্ধারিত হয় দূরত্ব, বইয়ের ওজন ও আকৃতি অনুসারে। তবে পাঠকের সুবিধার্থে একটি স্বচ্ছ ও নির্দিষ্ট ডেলিভারী চার্জ তালিকা অনুসরণ করা হয়।\n\n"
              "নিম্নে আমাদের ডেলিভারী চার্জের তালিকা প্রদান করা হলো:",
              style: TextStyle(
                fontFamily: "NotoSerif",
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 20),

            // 🚚 Courier Delivery Section
            _buildSection("🚚 অফিস/কুরিয়ার ডেলিভারী", [
              "১টি বই → ৬০ টাকা",
              "২টি বই → ১০০ টাকা [৬০ + ৪০]",
              "২টির বেশি বই → প্রতি অতিরিক্ত বই ২০ টাকা [৬০ + ৪০ + ২০ + …]",
            ]),

            const SizedBox(height: 20),

            // 🏠 Home Delivery Section
            _buildSection("🏠 হোম ডেলিভারী", [
              "১টি বই → ১০০ টাকা",
              "২টি বই → ১৪০ টাকা [১০০ + ৪০]",
              "২টির বেশি বই → প্রতি অতিরিক্ত বই ২০ টাকা [১০০ + ৪০ + ২০ + …]",
            ]),

            const SizedBox(height: 20),

            // 🎁 Special Offer Section
            _buildSection("🎁 বিশেষ সুবিধা", [
              "২০০০ টাকা বা তার বেশি মূল্যের যেকোনো বই → ফ্রি ডেলিভারী",
              "কম্বো প্যাক থেকে অর্ডার করলে → সর্বদা ফ্রি ডেলিভারী",
            ]),

            const SizedBox(height: 30),

            // ✅ Button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "বুঝেছি ✔",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Section Widget
  Widget _buildSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 10),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "• $point",
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
