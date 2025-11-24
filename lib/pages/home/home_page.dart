import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_library/library/log/log.dart';
import 'package:flutter_library/pages/home/home_navigator.dart';
import 'package:flutter_library/pages/home/home_recommand.dart';
import 'package:flutter_library/pages/home/recommand_item.dart';
import '../../library/carousel/image_carousel.dart';

import '../../library/carousel/custom_carousel.dart';

const List<String> _images = [
  "https://5lrorwxhlpmkiik.ldycdn.com/cloud/iqBqmKqoRilSnqipqmkp/banner1.png",
  "https://picsum.photos/400/200?random=1",
  'https://picsum.photos/400/200?random=2',
  'https://picsum.photos/400/200?random=3',
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('appbarTitle')),
      body: ListView(
        children: [
          ImageCarousel(
            imageUrls: _images,
            height: 222,
            indicatorPosition: IndicatorPosition.left,
            indicatorBackgroundColor: Colors.transparent,
            indicatorMargin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            indicatorColor: Colors.green,
            fit: BoxFit.fill,
          ),
          HomeNavigator(),
          HomeRecommand(),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            height: 50.0,
            child: Text('最新房源'),
          ),
          ListView.builder(
            itemCount: 20, // 列表项数量
            physics: NeverScrollableScrollPhysics(), // 禁止滚动
            shrinkWrap: true, // 根据子组件的高度自适应高度，如果父组件有高度约束，通常需要设置这个为true
            itemBuilder: (context, index) {
              RecommandItemData item = RecommandItemData(title: '根据子组件的高度自适应高度，如果父组件有高度约束，通常项目 $index',
                  image: 'https://picsum.photos/400/200?random=$index',
                  date: '2025-9-$index',
                  desc: '这是第 $index 个项目');
              return RecommandItem(item);
            },
          ),
        ],
      ),
    );
  }
}
