import 'package:flutter/material.dart';
import 'package:jd_app/Page/index_page.dart';
import 'package:jd_app/Provider/bottom_navi_provider.dart';
import 'package:jd_app/Provider/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: BottomNaviProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) {
            CartProvider provider = new CartProvider();
            provider.getCartList();
            return provider;
          },
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}
