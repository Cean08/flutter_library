import 'package:flutter/material.dart';
import 'package:flutter_library/library/app_router.dart';
import '../../library/log/log.dart';

class NavigatorItem {
  String title;
  IconData image;
  Function(BuildContext context) tap;

  NavigatorItem(this.title, this.image, this.tap);
}

List<NavigatorItem> _navigatorList = [
  NavigatorItem("整租", Icons.account_circle, (BuildContext context) {
    AppRouter.push(PagePath.roomDetail);
  }),
  NavigatorItem("合租", Icons.today_rounded, (BuildContext context) {
    AppRouter.push(PagePath.roomDetail);
  }),
  NavigatorItem("地图找房", Icons.find_in_page, (BuildContext context) {
    AppRouter.push(PagePath.roomDetail);
  }),
  NavigatorItem("去出租", Icons.outbond_rounded, (BuildContext context) {
    AppRouter.push(PagePath.roomDetail);
  }),
];

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navigatorList.map((item) => InkWell(
          onTap: () {
            item.tap(context);
          },
          child: Column(
            spacing: 6,
            children: [Icon(item.image), Text(item.title)],
          ),
        ),
      ).toList(),
      ),
    );
  }
}
