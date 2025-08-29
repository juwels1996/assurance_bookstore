import 'package:flutter/material.dart';

class AssurancePolicyScreen extends StatelessWidget {
  const AssurancePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Refund & Policy"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Company Logo (replace with your own logo asset if available)
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
              "Assurance Publications এর পক্ষ থেকে আপনাকে স্বাগতম।",
            ),
            _buildParagraph(
              "“অনুকরণ নয়, সৃজনশীলতাই উৎকর্ষ” – এই মূলমন্ত্র নিয়ে আমরা কাজ করে যাচ্ছি। "
              "আমাদের প্রকাশনা এবং কনটেন্টগুলো সম্পূর্ণ মৌলিকভাবে তৈরি করা হয়েছে যাতে শিক্ষার্থীরা "
              "সৃজনশীল চিন্তাধারা ও প্রতিযোগিতামূলক পরীক্ষার জন্য সঠিকভাবে প্রস্তুতি নিতে পারে।",
            ),
            _buildParagraph(
              "আমাদের Live MCQ অ্যাপটি Assurance Publications এর একান্ত প্রয়াস। "
              "এই অ্যাপটি বাংলাদেশের প্রথম ভার্চুয়াল পরীক্ষা কেন্দ্র, যেখানে শিক্ষার্থীরা একসাথে "
              "পরীক্ষায় অংশগ্রহণ করে নিজেদের প্রতিযোগিতামূলক দক্ষতা যাচাই করতে পারে।",
            ),
            _buildParagraph(
              "Live MCQ ইতিমধ্যেই বাংলাদেশের সবচেয়ে বড় অনলাইন টেস্ট প্ল্যাটফর্ম হওয়ার পথে অগ্রসর হচ্ছে।",
            ),
            _buildParagraph(
              "Live MCQ গণপ্রজাতন্ত্রী বাংলাদেশ সরকার কর্তৃক নিবন্ধিত এবং কপিরাইট আইন দ্বারা সুরক্ষিত। "
              "আমাদের কনটেন্ট অননুমোদিতভাবে ব্যবহার করা আইনত দণ্ডনীয় অপরাধ।",
            ),

            const SizedBox(height: 20),
            Text(
              "কপিরাইট আইন অনুযায়ী:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),

            _buildParagraph(
              "👉 কপিরাইট আইন, ২০০০ এর ধারা ৮১ অনুযায়ী, কপিরাইট লঙ্ঘন করলে অপরাধ হিসেবে গণ্য হবে "
              "এবং আদালতের বিচারাধীন হবে।",
            ),
            _buildParagraph(
              "👉 কপিরাইট আইন অনুযায়ী শাস্তি: সর্বোচ্চ ৪ (চার) বছর পর্যন্ত কারাদণ্ড বা সর্বোচ্চ ২ (দুই) লক্ষ টাকা জরিমানা "
              "বা উভয় দণ্ডে দণ্ডিত হতে পারে।",
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
              child: Text("I Agree", style: TextStyle(color: Colors.white)),
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
