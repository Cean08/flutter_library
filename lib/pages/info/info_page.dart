import 'package:flutter/material.dart';
import 'package:flutter_library/pages/home/recommand_item.dart';
import 'package:flutter_library/widgets/page_content.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('资讯')),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          RecommandItemData item = RecommandItemData(
            title: '根据子组件的高度自适应高度，如果父组件有高度约束，通常项目 $index',
            image: 'https://picsum.photos/400/200?random=$index',
            date: '2025-9-$index',
            desc: '这是第 $index 个项目',
          );
          return RecommandItem(item);
        },
      ),
    );
    ;
  }
}
