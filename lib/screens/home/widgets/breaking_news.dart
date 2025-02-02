import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BreakingNews extends StatefulWidget {
  const BreakingNews({Key? key}) : super(key: key);

  @override
  _BreakingNewsState createState() => _BreakingNewsState();
}

class _BreakingNewsState extends State<BreakingNews> {
  late Future<List<News>> breakingNewsList;
  late FlutterLocalNotificationsPlugin notificationsPlugin;

  @override
  void initState() {
    super.initState();
    breakingNewsList = fetchNews();
    initializeNotifications();
  }

  // Initialize local notifications
  void initializeNotifications() {
    notificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    notificationsPlugin.initialize(initializationSettings);
  }

  // Show notification
  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'breaking_news_channel',
      'Breaking News Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await notificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  // Fetch news data from API
  Future<List<News>> fetchNews() async {
    const String apiUrl = 'http://192.168.0.110:3000/best-news/approved-news';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['news'] != null) {
          final newsList = (data['news'] as List)
              .map((json) => News.fromJson(json))
              .toList();

          // Show notification when news is fetched
          if (newsList.isNotEmpty) {
            await showNotification(
              'Breaking News Update',
              'Fetched ${newsList.length} new articles.',
            );
          }
          return newsList;
        } else {
          throw Exception('No news data found in the response.');
        }
      } else {
        throw Exception(
            'Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching news: $e");
      throw Exception('Unable to fetch news. Please try again later.');
    }
  }

  // Refresh news data
  Future<void> refreshNews() async {
    setState(() {
      breakingNewsList = fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breaking News"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshNews,
          ),
        ],
      ),
      body: FutureBuilder<List<News>>(
        future: breakingNewsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load news. Please try again later.",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No breaking news found."));
          } else {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: news.image != null
                        ? Image.network(
                      news.image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.image_not_supported, size: 50),
                    title: Text(news.headline),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(news.underheadline ?? 'No description available'),
                        Text(
                          timeago.format(DateTime.parse(news.date ?? DateTime.now().toString())),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.share, color: Colors.blue),
                      onPressed: () {
                        final shareContent =
                            "Breaking News: ${news.headline}\n\n${news.underheadline ?? ''}\nRead more: ${news.url ?? 'No link available'}";
                        Share.share(shareContent);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailsScreen(news: news),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class News {
  final String id;
  final String headline;
  final String? underheadline;
  final String? content;
  final String? image;
  final String? url;
  final String? date;
  int likes;
  int dislikes;

  News({
    required this.id,
    required this.headline,
    this.underheadline,
    this.content,
    this.image,
    this.url,
    this.date,
    this.likes = 0,
    this.dislikes = 0,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'].toString(),
      headline: json['headline'],
      underheadline: json['underheadline'],
      content: json['content'],
      image: json['image'],
      url: json['url'],
      date: json['date'],
    );
  }
}

class NewsDetailsScreen extends StatelessWidget {
  final News news;

  const NewsDetailsScreen({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.headline),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.image != null)
                Image.network(
                  news.image!,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              const SizedBox(height: 16.0),
              Text(
                news.headline,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                news.underheadline ?? '',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Published Date: ${news.date ?? 'No date available'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              Text(
                news.content ?? 'No content available',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              if (news.url != null)
                ElevatedButton(
                  onPressed: () async {
                    final url = news.url!;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw Exception("Could not launch $url");
                    }
                  },
                  child: const Text("Read More"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
