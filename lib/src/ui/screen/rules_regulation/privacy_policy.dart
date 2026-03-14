import 'package:flutter/material.dart';

class AssurancePolicyScreen extends StatelessWidget {
  const AssurancePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Policy"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 80, color: Colors.orange),
            const SizedBox(height: 10),

            Text(
              "Assurance Publications",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildParagraph(
              "Assurance Publications এর পক্ষ থেকে আন্তরিক শুভেচ্ছা।",
            ),
            _buildParagraph(
              "আমাদের প্রকাশনা এবং কনটেন্টসমূহ সম্পূর্ণ নিজস্বভাবে প্রস্তুত করা হয়েছে যাতে শিক্ষার্থীরা "
              "উদ্ভাবনী চিন্তাভাবনা গড়ে তুলতে পারে এবং প্রতিযোগিতামূলক পরীক্ষার জন্য সঠিকভাবে অনুশীলন করতে পারে।",
            ),
            _buildParagraph(
              "আমাদের ওয়েবসাইট Assurance Publications এর নিরন্তর প্রচেষ্টা।",
            ),
            _buildParagraph(""),
            _buildParagraph(
              "Assurance Publications বাংলাদেশ সরকারের অনুমোদিত ও কপিরাইট আইন দ্বারা সুরক্ষিত। "
              "আমাদের বই অননুমোদিতভাবে বিক্রয় বা ব্যবহার করা আইনত শাস্তিযোগ্য অপরাধ।",
            ),

            const SizedBox(height: 20),
            Text(
              "কপিরাইট আইন অনুসারে:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),

            _buildParagraph(
              "👉 কপিরাইট আইন, ২০০০ এর ধারা ৮১ অনুযায়ী, কপিরাইট ভঙ্গ করা অপরাধ হিসেবে বিবেচিত হবে "
              "এবং আদালতের বিচারাধীন থাকবে।",
            ),
            _buildParagraph(
              "👉 কপিরাইট আইন অনুসারে শাস্তি: সর্বোচ্চ ৪ (চার) বছর পর্যন্ত কারাদণ্ড অথবা সর্বোচ্চ ২ (দুই) লক্ষ টাকা অর্থদণ্ড "
              "বা উভয় দণ্ড একসাথে প্রদান করা হতে পারে।",
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "I Agree",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
