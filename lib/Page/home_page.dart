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
                      AspectRatio(
                        aspectRatio: 72 / 35,
                        child: Swiper(
                          itemCount: model.swipers.length,
                          pagination: SwiperPagination(),
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            //assets/image: /image/jd1.jpg
                            return Image.asset(
                                "assets${model.swipers[index].image}");
                          },
                        ),
                      )
                    ],
                  );
                  //return Container();
                },
              ),
            )));
  }
}

// NetRequest() async {
//   var dio = Dio();
//   Response response = await dio.get(JdApi.HOME_PAGE);
//   print(response.data);
// }
