import 'package:flutter/material.dart';

class CateGoryPage extends StatefulWidget {
  CateGoryPage({Key key}) : super(key: key);

  @override
  _CateGoryPageState createState() => _CateGoryPageState();
}

class _CateGoryPageState extends State<CateGoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分類'),
      ),
      body: Container(),
    );
  }
}
