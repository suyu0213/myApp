import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/Model/home_page_model.dart';
import 'package:jd_app/Provider/home_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // NetRequest();
    // NetRequest().requestDate(JdApi.HOME_PAGE).then((res) => print(res.data));
    return ChangeNotifierProvider<HomePageProvider>(
        create: (context) {
          var provider = new HomePageProvider();
          provider.loadHomePageData();
          return provider;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('首頁'),
            ),
            body: Container(
              color: Color(0xFFf4f4f4),
              child: Consumer<HomePageProvider>(
                builder: (_, provider, __) {
                  // print(provider.isLoading);
                  //加載動畫
                  if (provider.isLoading) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  //捕獲異常
                  if (provider.isError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(provider.errorMsg),
                          OutlineButton(
                            child: Text("刷新"),
                            onPressed: () {
                              provider.loadHomePageData();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  HomePageModel model = provider.model;
                  print(model.toJson());

                  return ListView(
                    children: <Widget>[
                      //輪播圖
                      buildAspectRatio(model),
                      //圖標分類
                      buildLogos(model),
                      //掌上秒殺頭部
                      buildTGContainer(),
                      //掌上秒殺商品
                      buildTGBodyContainer(model),
                      //廣告1
                      buildAds(model.pageRow.ad1),
                      //廣告2
                      buildAds(model.pageRow.ad2),
                    ],
                  );
                  //return Container();
                },
              ),
            )));
  }

//廣告
  Widget buildAds(List<String> ads) {
    List<Widget> list = List<Widget>();

    for (int i = 0; i < ads.length; i++) {
      list.add(Expanded(
        child: Image.asset("assets${ads[i]}"),
      ));
    }

    return Row(
      children: list,
    );
  }

//掌上秒殺商品
  Container buildTGBodyContainer(HomePageModel model) {
    return Container(
      height: 120.0,
      color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.quicks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets${model.quicks[index].image}",
                    width: 85.0,
                    height: 85.0,
                  ),
                  Text(
                    "${model.quicks[index].price}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

//掌上秒殺頭部
  Container buildTGContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      height: 50.0,
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/image/bej.png",
            width: 90.0,
            height: 20.0,
          ),
          Spacer(),
          Text("更多秒殺"),
          Icon(
            CupertinoIcons.right_chevron,
            size: 14,
          ),
        ],
      ),
    );
  }

//圖標分類
  Widget buildLogos(HomePageModel model) {
    //定義一個list數據 列表
    List<Widget> list = List<Widget>();

    //遍歷model中的logo數組
    for (int i = 0; i < model.logos.length; i++) {
      list.add(Container(
        width: 60.0,
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets${model.logos[i].image}",
              width: 50.0,
              height: 50.0,
            ),
            Text("${model.logos[i].title}")
          ],
        ),
      ));
    }
    return Container(
      color: Colors.lime,
      height: 170,
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        spacing: 7.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.spaceBetween,
        children: list,
      ),
    );
  }

//輪播圖
  AspectRatio buildAspectRatio(HomePageModel model) {
    return AspectRatio(
      aspectRatio: 72 / 35,
      child: Swiper(
        itemCount: model.swipers.length,
        pagination: SwiperPagination(),
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          //assets/image: /image/jd1.jpg
          return Image.asset("assets${model.swipers[index].image}");
        },
      ),
    );
  }
}

// NetRequest() async {
//   var dio = Dio();
//   Response response = await dio.get(JdApi.HOME_PAGE);
//   print(response.data);
// }
