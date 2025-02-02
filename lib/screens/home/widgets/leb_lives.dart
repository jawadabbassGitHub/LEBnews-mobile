import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LebLives extends StatelessWidget {
  final List<Map<String, String>> lebanonNewsChannels = [
    {
      'name': 'Al Mayadeen Live',
      'url': 'https://www.youtube.com/watch?v=mNmidjq7oSw',
      'countryCode': 'LB',
    },
    {
      'name': 'LBCI Live',
      'url': 'https://www.youtube.com/watch?v=L83luPITbQg',
      'countryCode': 'LB',
    },
    {
      'name': 'MTV Live',
      'url': 'https://www.youtube.com/watch?v=KxS_yEHrIWA',
      'countryCode': 'LB',
    },
    {
      'name': 'Al Manar Live',
      'url': 'https://www.youtube.com/watch?v=G9meAuKFKoY',
      'countryCode': 'LB',
    },
  ];

  final List<Map<String, String>> internationalNewsChannels = [
    {
      'name': 'Al Jazeera Live',
      'url': 'https://www.youtube.com/watch?v=bNyUyrR0PHo',
      'countryCode': 'QA',
    },
    {
      'name': 'BBC Live',
      'url': 'https://www.youtube.com/watch?v=TV_RXBBRthE',
      'countryCode': 'US',
    },
    {
      'name': 'Syria TV Live',
      'url': 'https://www.youtube.com/watch?v=lekF0l28m5U',
      'countryCode': 'SY',
    },
  ];

  String _getFlag(String countryCode) {
    return 'assets/flags/$countryCode.png'; // Adjust based on your asset structure
  }

  Widget _buildChannelList(List<Map<String, String>> channels) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: channels.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final channel = channels[index];
        return ListTile(
          leading: Image.asset(
            _getFlag(channel['countryCode']!),
            width: 40,
            height: 40,
            errorBuilder: (_, __, ___) => const Icon(Icons.flag),
          ),
          title: Text(
            channel['name']!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.play_circle_fill, color: Colors.green),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(url: channel['url']!),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LebLives'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Lebanon News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildChannelList(lebanonNewsChannels),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'International News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildChannelList(internationalNewsChannels),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({required this.url, Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isValidUrl = true;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.url);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
        ),
      );
    } else {
      _isValidUrl = false;
    }
  }

  @override
  void dispose() {
    if (_isValidUrl) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream'),
        backgroundColor: Colors.red,
      ),
      body: _isValidUrl
          ? Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.green,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _controller.metadata.title.isNotEmpty
                  ? _controller.metadata.title
                  : 'Live Stream',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      )
          : const Center(
        child: Text(
          'Invalid YouTube URL',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  }
}
