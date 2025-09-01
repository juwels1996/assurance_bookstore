import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo / Banner
            Center(
              child: Column(
                children: [
                  Icon(Icons.book_rounded, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 8),
                  Text(
                    "Assurance Publications",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Serving knowledge for 24 years",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Introduction
            Text(
              "About Us",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Assurance Publications has been one of the leading and most trusted book publishers in Bangladesh for the past 24 years. "
              "We specialize in publishing high-quality and updated preparatory books tailored for competitive examinations.",
              style: TextStyle(
                fontFamily: "NotoSans",
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Specialization
            Text(
              "We Publish Books For:",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const BulletList(
              items: [
                "Bangladesh Civil Service (BCS)",
                "9th–20th Grade Government Jobs",
                "Primary Teacher Recruitment",
                "NTRCA",
                "Police (SI & Constable Recruitment)",
                "Bank",
                "And various other government job examinations",
              ],
            ),
            const SizedBox(height: 20),

            // Motto
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    "Our Motto",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "“We help you, You help the Nation.”",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Closing Statement
            const Text(
              "With decades of experience, a commitment to quality, and a deep understanding of the needs of job seekers, "
              "Assurance Publications has established itself as one of the oldest, most reliable, and reputable publishing houses in Bangladesh. "
              "We are dedicated to empowering candidates with the right resources to achieve their goals and serve the nation.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),

            // Footer / Contact
            Center(
              child: Text(
                "© 2025 Assurance Publications",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  const BulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 18, height: 1.4)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
