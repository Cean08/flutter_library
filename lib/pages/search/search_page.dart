import 'package:flutter/material.dart';
import 'package:flutter_library/pages/home/recommand_item.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('搜索')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Text('tabbar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                RecommandItemData item = RecommandItemData(title: '根据子组件的高度自适应高度，如果父组件有高度约束，通常项目 $index',
                    image: 'https://picsum.photos/400/200?random=$index',
                    date: '2025-9-$index',
                    desc: '这是第 $index 个项目');
                return RecommandItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
