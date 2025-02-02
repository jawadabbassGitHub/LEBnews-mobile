import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';

class LebNews extends StatefulWidget {
  const LebNews({Key? key}) : super(key: key);

  @override
  _LebNewsState createState() => _LebNewsState();
}

class _LebNewsState extends State<LebNews> {
  late Future<List<News>> newsList;
  late DateTime fetchTime;

  @override
  void initState() {
    super.initState();
    fetchTime = DateTime.now();
    newsList = fetchNews();
  }

  Future<List<News>> fetchNews() async {
    const String apiUrl = 'http://192.168.0.110:3000/api/news/get-all';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        fetchTime = DateTime.now();
        final data = json.decode(response.body);
        if (data['news'] != null) {
          return (data['news'] as List)
              .map((json) => News.fromJson(json))
              .toList();
        } else {
          throw Exception('No news data found in the response.');
        }
      } else {
        throw Exception(
            'Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<void> refreshNews() async {
    setState(() {
      newsList = fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lebanese News"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshNews,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshNews,
        child: FutureBuilder<List<News>>(
          future: newsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No news found."));
            } else {
              final news = snapshot.data!;
              return ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final newsItem = news[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: newsItem.photo != null && newsItem.photo!.isNotEmpty
                          ? Image.network(
                        "http://192.168.0.110:3000${newsItem.photo!}",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 50);
                        },
                      )
                          : const Icon(Icons.image_not_supported, size: 50),
                      title: Text(newsItem.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(newsItem.subTitle),
                          Text(
                            timeago.format(fetchTime),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue),
                        onPressed: () {
                          final shareContent =
                              "Lebanese News: ${newsItem.title}\n\n${newsItem.subTitle}\nhttp://192.168.0.103:3000/news/${newsItem.id}";
                          Share.share(shareContent);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailsScreen(news: newsItem),
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
      ),
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
        title: Text(news.title),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.photo != null && news.photo!.isNotEmpty)
              Image.network(
                "http://192.168.0.110:3000${news.photo!}",
                fit: BoxFit.cover,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            const SizedBox(height: 16.0),
            Text(
              news.title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              news.subTitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class News {
  final int id;
  final String title;
  final String subTitle;
  final String? photo;

  News({
    required this.id,
    required this.title,
    required this.subTitle,
    this.photo,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      subTitle: json['sub_title'],
      photo: json['news_photo'],
    );
  }
}
