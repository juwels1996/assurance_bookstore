import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📑 Terms & Conditions"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Last updated
              Text(
                "সর্বশেষ আপডেট: ১৩ জানুয়ারি ২০২৫",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),

              // Intro
              const Text(
                "Assurance Publications এর অফিসিয়াল Online Book Store-এ আপনাকে স্বাগতম। "
                "আমাদের ওয়েবসাইট ব্যবহার ও বই ক্রয়ের ক্ষেত্রে নিম্নলিখিত শর্তাবলি প্রযোজ্য হবে:",
                style: TextStyle(fontSize: 16, height: 1.6),
              ),

              const SizedBox(height: 25),

              // ১. বইয়ের আসল মূল্য
              _buildSection(
                "১. বইয়ের আসল মূল্য",
                "শুধুমাত্র Assurance Publications-এর প্রকাশিত সকল বই এর সঠিক মূল্যে এই ওয়েবসাইট হতে অর্ডার করতে পারবেন। "
                    "কোনো প্রকার অতিরিক্ত চার্জ বা ভিন্নমূল্য নেওয়া হবে না "
                    "(শুধুমাত্র ডেলিভারী চার্জ প্রযোজ্য হলে তা আলাদা উল্লেখ করা হবে)।",
              ),

              // ২. অর্ডার ও পেমেন্ট
              _buildSection(
                "২. অর্ডার ও পেমেন্ট",
                "অনলাইন বুক স্টোরে অর্ডার কেবলমাত্র পাঠকের বৈধ তথ্য ব্যবহার করে সম্পন্ন করতে হবে।\n"
                    "পেমেন্টের জন্য ওয়েবসাইটে উল্লেখিত নির্ধারিত পদ্ধতিগুলো ব্যবহার করতে হবে।\n"
                    "সফল অর্ডার ও পেমেন্ট সম্পন্ন হলে গ্রাহককে এসএমএসের মাধ্যমে নিশ্চিতকরণ পাঠানো হবে।",
              ),

              // ৩. ডেলিভারী নীতিমালা
              _buildSection(
                "৩. ডেলিভারী নীতিমালা",
                "অর্ডার করার সময় নির্ধারিত ঠিকানায় বই পাঠানো হবে, অর্ডার দেওয়ার ২-৩ কর্মদিবসের মধ্যে বই নির্ধারিত ঠিকানায় পৌঁছে যাবে।\n"
                    "নির্ধারিত সময়সীমার মধ্যে অর্ডার ডেলিভারী দেওয়ার চেষ্টা করা হবে; "
                    "তবে কুরিয়ার বা অন্য যেকোনো অনিবার্য কারণে বিলম্ব হলে তা অবশ্যই জানানো হবে।\n"
                    "নির্দিষ্ট শর্ত অনুযায়ী ফ্রি ডেলিভারী সুবিধা প্রযোজ্য হবে।",
              ),

              // ৪. রিটার্ন ও রিফান্ড নীতি
              _buildSection(
                "৪. রিটার্ন ও রিফান্ড নীতি",
                "ভুল বই প্রেরণ হলে বা বইয়ে গুরুতর প্রিন্টিং সমস্যা থাকলে কাস্টমার সার্ভিসে যোগাযোগ করতে হবে। "
                    "সঠিক প্রমাণ প্রদানের মাধ্যমে বই পরিবর্তন বা রিফান্ডের ব্যবস্থা নেওয়া হবে।\n\n"
                    "বই Exchange/অভিযোগ থাকলে বই ডেলিভারীর পর (৫-৭) কর্মদিবসের মধ্যে আমাদের কাস্টমার কেয়ার বা পেইজের ইনবক্সে জানাতে পারেন।\n\n"
                    "পাঠকের ভুলের কারণে Exchange করতে হলে অতিরিক্ত ডেলিভারী চার্জ পাঠককে বহন করতে হবে।\n\n"
                    "বাহ্যিক কুরিয়ার সার্ভিসের কারণে বিলম্ব বা ক্ষতির জন্য Assurance Publications সীমিত দায় বহন করবে।\n\n"
                    "বি.দ্র: শুধুমাত্র গ্রাহকের ভুল বা মত পরিবর্তনের কারণে রিটার্ন/রিফান্ড প্রযোজ্য নয়।",
              ),

              // ৫. শর্তাবলি পরিবর্তন
              _buildSection(
                "৫. শর্তাবলি পরিবর্তন",
                "প্রয়োজন অনুসারে এই Terms & Conditions সময়ের সাথে পরিবর্তিত হতে পারে।\n"
                    "ওয়েবসাইটে আপডেট প্রকাশের পর তাৎক্ষণিকভাবে নতুন শর্ত কার্যকর হবে।",
              ),

              const SizedBox(height: 40),

              // Button
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "আমি সম্মত ✅",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable Section Builder
  Widget _buildSection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 15, height: 1.6),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
