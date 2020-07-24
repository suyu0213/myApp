import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/Model/category_content_model.dart';
import 'package:jd_app/Provider/catagory_page_provider.dart';
import 'package:provider/provider.dart';

class CateGoryPage extends StatefulWidget {
  CateGoryPage({Key key}) : super(key: key);

  @override
  _CateGoryPageState createState() => _CateGoryPageState();
}

class _CateGoryPageState extends State<CateGoryPage> {
  @override
  Widget build(BuildContext context) {
    // NetRequest();
    // NetRequest().requestDate(JdApi.HOME_PAGE).then((res) => print(res.data));
    return ChangeNotifierProvider<CategoryPageProvider>(
        create: (context) {
          var provider = new CategoryPageProvider();
          provider.loadCategoryPageData();
          return provider;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('分類'),
            ),
            body: Container(
              color: Color(0xFFf4f4f4),
              child: Consumer<CategoryPageProvider>(
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
                              provider.loadCategoryPageData();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  // print(provider.categoryNavList);
                  return Row(
                    children: <Widget>[
                      //分類左側
                      buildNavLeftContainer(provider),
                      //分類右側
                      buildCategoryContent(provider.categoryContentList),
                    ],
                  );
                },
              ),
            )));
  }

//分類右側
  Widget buildCategoryContent(List<CategoryContentModel> contentList) {
    List<Widget> list = List<Widget>();
    return Container(
      width: 324,
      color: Colors.white,
      child: ListView(
        children: list,
      ),
    );
  }

//分類左側
  Container buildNavLeftContainer(CategoryPageProvider provider) {
    return Container(
      width: 90.0,
      child: ListView.builder(
        itemCount: provider.categoryNavList.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
                height: 50.0,
                padding: const EdgeInsets.only(top: 15.0),
                color: provider.tabIndex == index
                    ? Colors.white
                    : Color(0xFFF8F8F8),
                child: Text(
                  provider.categoryNavList[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: provider.tabIndex == index
                          ? Color(0xFFe93b3d)
                          : Color(0xFF333333),
                      fontWeight: FontWeight.w500),
                )),
            onTap: () {
              // print(index);
              provider.loadCategoryContentData(index);
            },
          );
        },
      ),
    );
  }
}
