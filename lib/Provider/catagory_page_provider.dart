import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:jd_app/Model/category_content_model.dart';
import 'package:jd_app/Net/net_reuqest.dart';
import 'package:jd_app/config/jd_api.dart';

class CategoryPageProvider with ChangeNotifier {
  bool isLoading = false;
  bool isError = false;
  String errorMsg = "";
  List<String> categoryNavList = [];
  List<CategoryContentModel> categoryContentList = [];
  int tabIndex = 0;

//分類左側
  loadCategoryPageData() {
    isLoading = true;
    isError = false;
    errorMsg = "";
    NetRequest().requestDate(JdApi.CATEGORY_NAV).then((res) {
      isLoading = false;
      // print(res.data);
      if (res.data is List) {
        for (int i = 0; i < res.data.length; i++) {
          categoryNavList.add(res.data[i]);
        }
        loadCategoryContentData(this.tabIndex);
      }
      notifyListeners();
    }).catchError((error) {
      print(error);
      errorMsg = error;
      isLoading = false;
      isError = true;
      notifyListeners();
    });
  }

//分類右側
  loadCategoryContentData(int index) {
    tabIndex = index;
    isLoading = true;
    categoryContentList.clear();
    //請求數據
    var data = {"title": categoryNavList[index]};
    NetRequest()
        .requestDate(JdApi.CATEGORY_CONTENT, data: data, method: "post")
        .then((res) {
      isLoading = false;
      print(res.data);
      if (res.data is List) {
        for (var item in res.data) {
          CategoryContentModel tmpModel = CategoryContentModel.fromJson(item);
          categoryContentList.add(tmpModel);
        }
      }
      notifyListeners();
    }).catchError((error) {
      print(error);
      errorMsg = error;
      isLoading = false;
      isError = true;
      notifyListeners();
    });
    notifyListeners();
  }
}
