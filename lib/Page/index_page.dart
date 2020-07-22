import 'package:flutter/material.dart';
import 'package:jd_app/Page/home_page.dart';
import 'package:jd_app/Page/category_page.dart';
import 'package:jd_app/Page/cart_page.dart';
import 'package:jd_app/Page/user_page.dart';
import 'package:jd_app/Provider/bottom_navi_provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Consumer<BottomNaviProvider>(
          builder: (_, mProvider, __) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: mProvider.bottomNaviIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('首頁'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  title: Text('分類'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  title: Text('購物車'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text('我的'),
                ),
              ],
              onTap: (index) {
                //print(index);
                mProvider.changeBottomNaviIndex(index);
              },
            );
          },
        ),
        body: Consumer<BottomNaviProvider>(
          builder: (_, mProvider, __) => IndexedStack(
            //層布局控件 只顯示一個
            index: mProvider.bottomNaviIndex,
            children: <Widget>[
              HomePage(),
              CateGoryPage(),
              CartPage(),
              UserPage(),
            ],
          ),
        ));
  }
}
