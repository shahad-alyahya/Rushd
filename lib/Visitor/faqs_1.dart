import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // قائمة الأسئلة والأجوبة المحدثة لنظام "رشد" المؤتمت
  final List<Map<String, dynamic>> faqs = [
    {
      "id": "01",
      "question": "What is the purpose of Rushd?",
      "answer":
          "Rushd is an automated system designed to manage crowd flow and organize movement in crowded areas. It helps visitors find the most efficient paths to their destination while avoiding congestion.",
      "isExpanded": true,
    },
    {
      "id": "02",
      "question": "How to register in the application?",
      "answer":
          "You can easily register by navigating to the Sign-Up page, providing your basic information (Name, Email, and Phone), and creating a secure password to access visitor features.",
      "isExpanded": false,
    },
    {
      "id": "03",
      "question": "What is the congestion level system?",
      "answer":
          "Our system uses automated monitoring to categorize zones: Green for low density, Yellow for moderate, and Red for high density. This helps you decide the best time and route for your movement.",
      "isExpanded": false,
    },
    {
      "id": "04",
      "question": "Forgot your password? How to reset it.",
      "answer":
          "If you forget your password, go to the Sign-In screen and click 'Forgot Password' to receive reset instructions, or update it via the 'Edit Profile' section once logged in.",
      "isExpanded": false,
    },
    {
      "id": "05",
      "question": "How to contact support?",
      "answer":
          "You can reach out to our team through the 'Contact Us' page in your profile for any inquiries or technical support regarding the application.",
      "isExpanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return _buildFAQItem(index);
        },
      ),
    );
  }

  Widget _buildFAQItem(int index) {
    bool isExpanded = faqs[index]['isExpanded'];

    return InkWell(
      onTap: () {
        setState(() {
          faqs[index]['isExpanded'] = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: isExpanded ? const Color(0xFFF3F0FA) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              faqs[index]['id'],
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: isExpanded
                    ? const Color(0xFF673AB7).withOpacity(0.2)
                    : Colors.grey.shade200,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    faqs[index]['question'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.remove_circle_outline
                      : Icons.add_circle_outline,
                  color: isExpanded ? const Color(0xFF673AB7) : Colors.black45,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 15),
              Text(
                faqs[index]['answer'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
