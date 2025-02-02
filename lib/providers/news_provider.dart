import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:final_news_app_senior/common/colors.dart';
import 'package:final_news_app_senior/models/listdata_model.dart';
import 'package:final_news_app_senior/models/news_model.dart';
import 'package:final_news_app_senior/services/Api.dart';

class NewsProvider {
  // Modify to accept an optional searchKeyword
  Future<ListData> GetEverything(String keyword, int page, [String? searchKeyword]) async {
    ListData articles = ListData([], 0, false);

    // Pass the searchKeyword to the API service if it's not null or empty
    await ApiService().getEverything(keyword, page, searchKeyword).then((response) {
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body)['articles'];
        articles = ListData(
          data.map((e) => News.fromJson(e)).toList(),
          jsonDecode(response.body)['totalResults'],
          true,
        );
      } else {
        Fluttertoast.showToast(
          msg: jsonDecode(response.body)['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.lighterGray,
          textColor: AppColors.black,
          fontSize: 16.0,
        );
        throw Exception(response.statusCode);
      }
    });
    return articles;
  }
}
