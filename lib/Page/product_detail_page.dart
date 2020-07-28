import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jd_app/Model/product_detail_model.dart';
import 'package:jd_app/Provider/bottom_navi_provider.dart';
import 'package:jd_app/Provider/cart_provider.dart';
import 'package:jd_app/Provider/product_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  ProductDetailPage({Key key, this.id}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("電商"),
      ),
      body: Container(
        child: Consumer<ProductDetailProvider>(
          builder: (_, provider, __) {
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
                        provider.loadProduct(id: widget.id);
                      },
                    ),
                  ],
                ),
              );
            }
            //獲取model
            ProductDetailModel model = provider.model;
            String gfTitle = "[首次支付]享優惠";
            print(model.toJson());

            for (var item in model.baitiao) {
              if (item.select == true) {
                gfTitle = item.desc;
              }
            }

            return Stack(
              children: <Widget>[
                //主體內容
                ListView(
                  children: <Widget>[
                    //輪播圖
                    buildSwiperContainer(model),
                    //標題
                    buildTitleContainer(model),
                    //價格
                    buildPriceContainer(model),
                    //支付
                    buildPayContainer(context, gfTitle, model, provider),

                    //商品數量
                    buildCountContainer(context, model, provider)
                  ],
                ),

                //底部菜單欄
                buildBottomPositioned(context, model)
              ],
            );
          },
        ),
      ),
    );
  }

  Positioned buildBottomPositioned(
      BuildContext context, ProductDetailModel model) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 1.0, color: Color(0xFFE8E8ED)))),
        child: Row(
          children: <Widget>[
            Expanded(
                child: InkWell(
              child: Container(
                  height: 60.0,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                              width: 40.0,
                              height: 30.0,
                              child: Icon(Icons.shopping_cart)),
                          Consumer<CartProvider>(
                              builder: (_, cartProvider, __) {
                            return Positioned(
                              right: 0.0,
                              child: cartProvider.getAllCount() > 0
                                  ? Container(
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(11.0)),
                                      child: Text(
                                        "${cartProvider.getAllCount()}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0),
                                      ),
                                    )
                                  : Container(),
                            );
                          }),
                        ],
                      ),
                      Text(
                        "購物車",
                        style: TextStyle(fontSize: 13.0),
                      )
                    ],
                  )),
              onTap: () {
                //購物車
                //先回到頂層
                Navigator.popUntil(context, ModalRoute.withName("/"));
                //跳轉到購物車
                Provider.of<BottomNaviProvider>(context, listen: false)
                    .changeBottomNaviIndex(2);
              },
            )),
            Expanded(
              child: InkWell(
                child: Container(
                  height: 60.0,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(
                    "加入購物車",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  //加入購物車
                  Provider.of<CartProvider>(context, listen: false)
                      .addToCart(model.partData);
                  Fluttertoast.showToast(
                    msg: "成功加入購物車",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    fontSize: 16.0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildCountContainer(BuildContext context, ProductDetailModel model,
      ProductDetailProvider provider) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(width: 1, color: Color(0xFFE8E8ED)),
            bottom: BorderSide(width: 1, color: Color(0xFFE8E8ED))),
      ),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Text(
              "已選",
              style: TextStyle(color: Color(0xFF999999)),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text("${model.partData.count}件"),
              ),
            ),
            Icon(Icons.more_horiz),
          ],
        ),
        onTap: () {
          //選擇商品個數
          return showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return ChangeNotifierProvider.value(
                  value: provider,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.only(top: 20.0),
                      ),
                      //頂部: 包含圖片 價格 數量訊息
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Image.asset(
                              "assets${model.partData.loopImgUrl[0]}",
                              width: 90.0,
                              height: 90.0,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "\$${model.partData.price}",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFd93d3d)),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "已選擇${model.partData.count}件",
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: IconButton(
                              icon: Icon(Icons.close),
                              iconSize: 20.0,
                              onPressed: () {
                                //pop
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),

                      //中間: 數量 加減號
                      Container(
                        margin: EdgeInsets.only(
                          top: 90.0,
                          bottom: 50.0,
                        ),
                        padding: EdgeInsets.only(top: 40.0, left: 15.0),
                        child: Consumer<ProductDetailProvider>(
                            builder: (_, tmpProvider, __) {
                          return Row(
                            children: <Widget>[
                              Text("數量"),
                              Spacer(),
                              InkWell(
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  color: Color(0xFFF7F7F7),
                                  child: Center(
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xFFB0B0B0)),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  //減號
                                  int tmpCount = model.partData.count;
                                  tmpCount--;
                                  provider.changeProductCount(tmpCount);
                                },
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Container(
                                width: 35.0,
                                height: 35.0,
                                child: Center(
                                  child: Text("${model.partData.count}"),
                                ),
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              InkWell(
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  color: Color(0xFFF7F7F7),
                                  child: Center(
                                    child: Text(
                                      "+",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  //加號
                                  int tmpCount = model.partData.count;
                                  tmpCount++;
                                  provider.changeProductCount(tmpCount);
                                },
                              ),
                            ],
                          );
                        }),
                      ),

                      //底部: 加入購物車按鈕
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          child: Container(
                            height: 50.0,
                            color: Color(0xFFe93b3b),
                            alignment: Alignment.center,
                            child: Text(
                              "加入購物車",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {
                            //加入購物車
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(model.partData);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  Container buildPayContainer(BuildContext context, String gfTitle,
      ProductDetailModel model, ProductDetailProvider provider) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(width: 1, color: Color(0xFFE8E8ED)),
            bottom: BorderSide(width: 1, color: Color(0xFFE8E8ED))),
      ),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Text(
              "支付",
              style: TextStyle(color: Color(0xFF999999)),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text("$gfTitle"),
              ),
            ),
            Icon(Icons.more_horiz),
          ],
        ),
        onTap: () {
          //選擇支付 分期
          // print(gfTitle);
          buildShowGF(context, model, provider);
        },
      ),
    );
  }

  Future buildShowGF(BuildContext context, ProductDetailModel model,
      ProductDetailProvider provider) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ChangeNotifierProvider<ProductDetailProvider>.value(
            value: provider,
            child: Stack(
              children: <Widget>[
                //頂部標題
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      color: Color(0xFFF3F2F8),
                      child: Center(
                        child: Text(
                          "購買",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                          child: IconButton(
                              icon: Icon(Icons.close),
                              iconSize: 20.0,
                              onPressed: () {
                                //關閉
                                Navigator.pop(context);
                              })),
                    ),
                  ],
                ),
                //主體列表
                Container(
                  margin: EdgeInsets.only(top: 40.0, bottom: 50.0),
                  child: ListView.builder(
                      itemCount: model.baitiao.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Consumer<ProductDetailProvider>(
                                    builder: (_, tmpProvider, __) {
                                      return Image.asset(
                                        model.baitiao[index].select
                                            ? "assets/image/selected.png"
                                            : "assets/image/unselect.png",
                                        width: 20.0,
                                        height: 20.0,
                                      );
                                    },
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${model.baitiao[index].desc}"),
                                    Text("${model.baitiao[index].tip}"),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            //選擇分期類型
                            provider.changeBaitiaoSelected(index);
                          },
                        );
                      }),
                ),
                //底部按鈕
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      color: Color(0xFFe4393c),
                      child: Center(
                        child: Text(
                          "立即付款",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    onTap: () {
                      //確定分期方式並返回
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container buildPriceContainer(ProductDetailModel model) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Text(
        "\$${model.partData.price}",
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFd93b3d)),
      ),
    );
  }

  Container buildTitleContainer(ProductDetailModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Text(
        model.partData.title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container buildSwiperContainer(ProductDetailModel model) {
    return Container(
      color: Colors.white,
      height: 400.0,
      child: Swiper(
        itemCount: model.partData.loopImgUrl.length,
        pagination: SwiperPagination(),
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            "assets${model.partData.loopImgUrl[index]}",
            width: double.infinity,
            height: 400.0,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}
