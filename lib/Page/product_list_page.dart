import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/Model/productlist_info_model.dart';
import 'package:jd_app/Page/product_detail_page.dart';
import 'package:jd_app/Provider/product_detail_provider.dart';
import 'package:jd_app/Provider/product_list_provider.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  final String title;
  ProductListPage({Key key, this.title}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.title}"),
        ),
        body: Container(
          color: Color(0xFFF7F7F7),
          child: Consumer<ProductListProvider>(builder: (_, provider, __) {
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
                        provider.loadProductList();
                      },
                    ),
                  ],
                ),
              );
            }

            //返回數據展示
            return ListView.builder(
                itemCount: provider.list.length,
                itemBuilder: (context, index) {
                  ProductInfoModel model = provider.list[index];
                  // print(model.toJson());

                  //展示數據
                  return InkWell(
                    child: buildProductItem(model),
                    onTap: () {
                      //前往商品詳情頁面
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<ProductDetailProvider>(
                                create: (context) {
                                  ProductDetailProvider provider =
                                      ProductDetailProvider();
                                  provider.loadProduct(id: model.id);
                                  return provider;
                                },
                                child: Consumer<ProductDetailProvider>(
                                  builder: (_, Provider, __) {
                                    return Container(
                                      child: ProductDetailPage(id: model.id),
                                    );
                                  },
                                ),
                              )));
                    },
                  );
                });
          }),
        ),
      ),
    );
  }

  Row buildProductItem(ProductInfoModel model) {
    return Row(
      children: <Widget>[
        Image.asset(
          "assets${model.cover}",
          width: 90.0,
          height: 120.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5.0),
                Text(
                  "\$${model.price}",
                  style: TextStyle(fontSize: 16.0, color: Color(0xFFe93b3d)),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    Text(
                      "${model.comment}條評價",
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF999999)),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "好評率${model.rate}",
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF999999)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
