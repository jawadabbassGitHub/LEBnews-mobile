import 'package:final_news_app_senior/screens/home/widgets/AboutPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loadmore/loadmore.dart';
import 'package:final_news_app_senior/common/colors.dart';
import 'package:final_news_app_senior/common/widgets/no_connectivity.dart';
import 'package:final_news_app_senior/models/listdata_model.dart';
import 'package:final_news_app_senior/models/news_model.dart' as m;
import 'package:final_news_app_senior/providers/news_provider.dart';
import 'package:final_news_app_senior/screens/home/widgets/leb_lives.dart';
import 'package:final_news_app_senior/screens/home/widgets/newsCard.dart';
import 'package:final_news_app_senior/screens/home/widgets/CategoryItem.dart';
import 'package:final_news_app_senior/screens/home/widgets/weather_page.dart';
import 'package:final_news_app_senior/screens/home/widgets/lebnews.dart';
import '../../common/common.dart';
import '../welcome.dart';
import 'widgets/breaking_news.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  int activeCategory = 0;
  int page = 1;
  bool isFinish = false;
  bool data = false;
  List<m.News> articles = [];
  String searchKeyword = '';

  Offset _buttonPosition = Offset(200, 500); // Initial floating button position

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    if (await getInternetStatus()) {
      getNewsData();
    } else {
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(
        builder: (context) => const NoConnectivity(),
      ))
          .then((value) => checkConnectivity());
    }
  }

  Future<bool> getNewsData() async {
    ListData listData = await NewsProvider().GetEverything(
      categories[activeCategory].toString(),
      page++,
      searchKeyword,
    );

    if (listData.status) {
      List<m.News>? items =
      listData.data is List<m.News> ? listData.data as List<m.News> : [];
      data = true;

      if (mounted) {
        setState(() {});
      }

      if (items.length == listData.totalContent) {
        isFinish = true;
      }

      if (items.isNotEmpty) {
        setState(() {
          articles.addAll(items);
        });
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LEBnews",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 5,
        iconTheme: const IconThemeData(color: AppColors.black),
        actions: [
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Adjusted padding
            child: Container(
              width: 200, // Adjust as needed
              height: 40, // Ensure consistent height
              decoration: BoxDecoration(
                color: Colors.grey[200], // Optional background color
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: AppColors.black),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Adjusted internal padding
                  prefixIcon: Icon(Icons.search, color: AppColors.black), // Optional search icon
                ),
                style: TextStyle(color: AppColors.black),
                onSubmitted: (value) {
                  setState(() {
                    searchKeyword = value;
                    articles = [];
                    page = 1;
                    isFinish = false;
                  });
                  getNewsData();
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              child: const Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_tv),
              title: const Text('LebLives'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LebLives()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('LEB News'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LebNews()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Weather'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeatherPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flash_on),
              title: const Text('عاجل'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BreakingNews()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login For Vip'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: size.width,
                  child: ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => CategoryItem(
                      index: index,
                      categoryName: categories[index],
                      activeCategory: activeCategory,
                      onClick: () {
                        setState(() {
                          activeCategory = index;
                          articles = [];
                          page = 1;
                          isFinish = false;
                          data = false;
                        });
                        getNewsData();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * 0.8,
                  child: LoadMore(
                    isFinish: isFinish,
                    onLoadMore: getNewsData,
                    whenEmptyLoad: true,
                    delegate: const DefaultLoadMoreDelegate(),
                    textBuilder: DefaultLoadMoreTextBuilder.english,
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) => NewsCard(
                        article: articles[index],
                        searchKeyword: searchKeyword,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height / 3,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.red.withOpacity(0.7),
                child: const Icon(Icons.live_tv),
              ),
              childWhenDragging: Container(),
              onDragEnd: (dragDetails) {
                setState(() {
                  _buttonPosition = dragDetails.offset;
                });
              },
              child: MouseRegion(
                onEnter: (_) {
                  Fluttertoast.showToast(
                    msg: "This is for live streaming",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LebLives(),
                      ),
                    );
                  },
                  child: const Icon(Icons.live_tv),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 100,
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BreakingNews()),
                );
              },
              child: const Icon(Icons.flash_on),
            ),
          ),
        ],
      ),
    );
  }
}
