import 'package:flutter/material.dart';
import 'package:final_news_app_senior/common/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  // Function to handle phone dialing
  void _dialPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
  void requestCallPermission() async {
    if (await Permission.phone.request().isGranted) {
      // Permission granted
    } else {
      // Handle the denied permission
    }
  }

  // Function to handle sending an email
  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Contact%20LEBnews&body=Hello,', // Optional email subject and body
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About LEBnews",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "LEBnews is your trusted source for the latest news updates, breaking news, and detailed coverage of events from around the globe. We provide news categorized by topics like Business, Health, Entertainment, and more, ensuring you stay informed about what matters to you.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _dialPhoneNumber("+96171734509"),
              child: Row(
                children: const [
                  Icon(Icons.phone, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "+961 71 734509",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _sendEmail("jawadabbass51@gmail.com"),
              child: Row(
                children: const [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "jawadabbass51@gmail.com",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Have questions? Feel free to contact us directly via phone or email. We are always happy to hear from you and assist with any inquiries.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
