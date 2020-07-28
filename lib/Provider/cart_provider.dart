import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:jd_app/Model/product_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<PartData> models = [];

  Future<void> addToCart(PartData data) async {
    // print(data.toJson());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //存入緩存
    // List<String> list = [];
    // list.add(json.encode(data.toJson()));
    // prefs.setStringList("cartInfo", list);

    //取出緩存
    // list = prefs.getStringList("certInfo");
    // print(list);

    //先把緩存裡的數據取出來
    List<String> list = [];
    list = prefs.getStringList("cartInfo");
    //判斷取出來的list有沒有東西
    if (list == null) {
      print("緩存沒有數據");
      //將傳遞過來的數據存到緩存中
      list.add(json.encode(data.toJson()));
      //存到緩存
      prefs.setStringList("cartInfo", list);
      //更新本地數據
      models.add(data);
      //通知聽眾
      notifyListeners();
    } else {
      print("緩存有商品數據");
      //定義臨時數組
      List<String> tmpList = [];
      //判斷緩存中是否有對應商品
      bool isUpdated = false;
      //遍歷緩存數據
      for (int i = 0; i < list.length; i++) {
        PartData tmpData = PartData.fromJson(json.decode(list[i]));

        //判斷商品id
        if (tmpData.id == data.id) {
          tmpData.count = data.count;
          isUpdated = true;
        }

        //放到數組中
        String tmpDataStr = json.encode(tmpData.toJson());
        tmpList.add(tmpDataStr);
        models.add(tmpData);
      }

      //如果緩存裡的數組沒有現在的商品 直接添加
      if (isUpdated == false) {
        String str = json.encode(data.toJson());
        tmpList.add(str);
        models.add(data);
      }

      //存入緩存
      prefs.setStringList("cartInfo", tmpList);

      //通知聽眾
      notifyListeners();
    }
  }

  //獲取購物車商品數量
  int getAllCount() {
    int count = 0;
    for (PartData data in this.models) {
      count += data.count;
    }
    return count;
  }
}
