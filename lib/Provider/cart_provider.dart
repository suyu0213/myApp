import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:jd_app/Model/product_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<PartData> models = [];
  bool isSelectAll = false;

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
    models.clear();

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

  //獲取購物車商品
  void getCartList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> list = [];

    //取出緩存
    list = prefs.getStringList("certInfo");
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        PartData tmpData = PartData.fromJson(json.decode(list[i]));
        models.add(tmpData);
      }
      notifyListeners();
    }
  }

  //刪除商品
  void removeFromCart(String id) async {
    //從緩存中刪除
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = [];

    //取出緩存
    list = prefs.getStringList("certInfo") ?? [];
    //遍歷緩存數據
    for (int i = 0; i < list.length; i++) {
      PartData tmpData = PartData.fromJson(json.decode(list[i]));
      if (tmpData.id == id) {
        list.remove(list[i]);
        break;
      }
    }

    //遍歷本地數據
    for (int i = 0; i < models.length; i++) {
      if (this.models[i].id == id) {
        this.models.remove(this.models[i]);
        break;
      }
    }

    //緩存重新賦值
    prefs.setStringList("cartInfo", list);

    notifyListeners();
  }

  //選中狀態
  void changeSelectedId(String id) {
    int tmpCount = 0;
    // print(id);
    for (int i = 0; i < this.models.length; i++) {
      if (id == this.models[i].id) {
        this.models[i].isSelected = !this.models[i].isSelected;
      }
      if (this.models[i].isSelected) {
        tmpCount++;
      }
    }

    //如果tmpCount的個數和.models.lenght一致 那就是全選狀態
    if (tmpCount == this.models.length) {
      this.isSelectAll = true;
    } else {
      this.isSelectAll = false;
    }
    notifyListeners();
  }

  //全選
  void changeSelectAll() {
    isSelectAll = !isSelectAll;
    for (int i = 0; i < this.models.length; i++) {
      this.models[i].isSelected = isSelectAll;
    }
    notifyListeners();
  }

  //統計合計金額
  String getAmount() {
    String amountStr = "0.00";

    for (int i = 0; i < this.models.length; i++) {
      if (this.models[i].isSelected == true) {
        num price = this.models[i].count *
            NumUtil.getNumByValueStr(this.models[i].price, fractionDigits: 2);
        num amount = NumUtil.getNumByValueStr(amountStr, fractionDigits: 2);
        amountStr = NumUtil.add(amount, price).toString();
      }
    }
    return amountStr;
  }

  //統計選中商品個數
  int getSelectedCount() {
    int selectedCount = 0;
    for (int i = 0; i < this.models.length; i++) {
      if (this.models[i].isSelected == true) {
        selectedCount++;
      }
    }
    return selectedCount;
  }
}
