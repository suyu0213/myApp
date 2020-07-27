class JdApi {
  static const String BASE_URL = "https://flutter-jdapi.herokuapp.com/api";
  //返回首頁請求的json
  static const String HOME_PAGE = BASE_URL + "/profiles/homepage";
  //分類的導航
  static const String CATEGORY_NAV = BASE_URL + "/profiles/navigationLeft";
  //分類導航的商品json
  static const String CATEGORY_CONTENT = BASE_URL + "/profiles/navigationRight";
  //返回的商品列表json
  static const String PRODUCTIONS_LIST = BASE_URL + "/profiles/productionsList";
  //返回商品詳細的json
  static const String PRODUCTIONS_DETAIL =
      BASE_URL + "/profiles/productionDetail";
}
