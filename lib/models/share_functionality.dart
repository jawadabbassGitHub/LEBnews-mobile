import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ShareOptions(),
    );
  }
}

class ShareOptions extends StatelessWidget {
  final String shareUrl = "https://youtu.be/BU6zSWTrTMQ"; // Example URL

  void _share(String platform) async {
    String url;
    switch (platform) {
      case 'WhatsApp':
        url = "https://wa.me/?text=$shareUrl";
        break;
      case 'Facebook':
        url = "https://www.facebook.com/sharer/sharer.php?u=$shareUrl";
        break;
      case 'X':
        url = "https://twitter.com/intent/tweet?url=$shareUrl";
        break;
      case 'Email':
        url = "mailto:?subject=Check this out&body=$shareUrl";
        break;
      case 'KakaoTalk':
        url = "https://sharer.kakao.com/talk/friends/pick"; // Example Kakao URL
        break;
      default:
        url = shareUrl;
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 250,
      child: Column(
        children: [
          const Text(
            'Share',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareIconWithImage(
                  'WhatsApp', 'assets/images/whatsapp.png', context),
              _buildShareIcon(
                  'Facebook', Icons.facebook, Colors.blue, context),
              _buildShareIcon('X', Icons.share, Colors.black, context),
              _buildShareIcon('Email', Icons.email, Colors.red, context),
              _buildShareIcon('KakaoTalk', Icons.message, Colors.yellow, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareIcon(
      String platform, IconData icon, Color color, BuildContext context) {
    return InkWell(
      onTap: () => _share(platform),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(platform, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildShareIconWithImage(
      String platform, String imagePath, BuildContext context) {
    return InkWell(
      onTap: () => _share(platform),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(platform, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
