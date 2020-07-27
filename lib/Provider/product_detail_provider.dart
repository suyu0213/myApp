import 'package:flutter/material.dart';
import 'package:jd_app/Model/product_detail_model.dart';
import 'package:jd_app/Net/net_reuqest.dart';
import 'package:jd_app/config/jd_api.dart';

class ProductDetailProvider with ChangeNotifier {
  ProductDetailModel model;
  bool isLoading = false;
  bool isError = false;
  String errorMsg = "";

  loadProduct({String id}) {
    isLoading = true;
    isError = false;
    errorMsg = "";
    NetRequest().requestDate(JdApi.PRODUCTIONS_DETAIL).then((res) {
      isLoading = false;
      // print(res.data);
      if (res.code == 200 && res.data is List) {
        for (var item in res.data) {
          ProductDetailModel tmpModel = ProductDetailModel.fromJson(item);
          if (tmpModel.partData.id == id) {
            model = tmpModel;
          }
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
  }
}
