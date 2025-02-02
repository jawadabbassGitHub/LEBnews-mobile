import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:final_news_app_senior/common/colors.dart';
import 'package:final_news_app_senior/models/news_model.dart';
import 'package:final_news_app_senior/screens/news_info/news_info.dart';
import 'package:skeletons/skeletons.dart';

class NewsCard extends StatefulWidget {
  final News article;
  final String searchKeyword; // Accept the search keyword

  const NewsCard({
    super.key,
    required this.article,
    required this.searchKeyword, // Initialize searchKeyword
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => NewsInfo(
              news: widget.article,
            ),
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 0.2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.article.urlToImage.toString(),
                    fit: BoxFit.contain,
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      if (frame == null) {
                        return Center(
                          child: Skeleton(
                            isLoading: true,
                            skeleton: SkeletonParagraph(),
                            child: const Text(''),
                          ),
                        );
                      }
                      return child;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    // Highlight the keyword in the title
                    child: RichText(
                      text: _highlightKeyword(
                          widget.article.title.toString(),
                          widget.searchKeyword),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.person,
                            color: AppColors.black,
                            size: 20,
                          ),
                          SizedBox(
                            width: size.width / 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.article.author.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppColors.black,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Text(
                              Jiffy.parse(
                                widget.article.publishedAt.toString(),
                              ).fromNow().toString(),
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    // Highlight the keyword in the description
                    child: RichText(
                      text: _highlightKeyword(
                          widget.article.description.toString(),
                          widget.searchKeyword),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to highlight the keyword in the given text
  TextSpan _highlightKeyword(String text, String keyword) {
    if (keyword.isEmpty || !text.toLowerCase().contains(keyword.toLowerCase())) {
      return TextSpan(text: text, style: const TextStyle(color: Colors.black));
    }

    List<TextSpan> spans = [];
    int start = 0;
    int keywordIndex = text.toLowerCase().indexOf(keyword.toLowerCase());

    while (keywordIndex != -1) {
      if (start != keywordIndex) {
        spans.add(TextSpan(
            text: text.substring(start, keywordIndex),
            style: const TextStyle(color: Colors.black)));
      }

      // Add the highlighted keyword with bold styling
      spans.add(TextSpan(
        text: text.substring(keywordIndex, keywordIndex + keyword.length),
        style: const TextStyle(
          color: Colors.black,  // Black text color
          backgroundColor: Colors.yellow,  // Yellow background
          fontWeight: FontWeight.bold,  // Bold for emphasis
        ),
      ));

      start = keywordIndex + keyword.length;
      keywordIndex = text.toLowerCase().indexOf(keyword.toLowerCase(), start);
    }

    if (start < text.length) {
      spans.add(TextSpan(
          text: text.substring(start), style: const TextStyle(color: Colors.black)));
    }

    return TextSpan(children: spans);
  }
}
