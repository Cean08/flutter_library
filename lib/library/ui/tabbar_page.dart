import 'package:flutter/material.dart';
import 'package:flutter_library/pages/demo/demo_page.dart';
import '../../pages/info/info_page.dart';
import '../../pages/search/search_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/mine/mine_page.dart';


class TabBarPage extends StatefulWidget {
  final int index;
  const TabBarPage({super.key, this.index=0});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int _currentIndex = 0;
  // 页面集合
  final List<Widget> _pages = [
    const DemoPage(),
    const HomePage(),
    const SearchPage(),
    const InfoPage(),
    const MinePage(),
  ];

  // tabBar item
  final List<BottomNavigationBarItem> _tabItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance),
      label: 'Demo',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '首页',
      // backgroundColor: Colors.yellow,//指定背景颜色（shifting 类型生效）
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: '搜索',
    ),
    BottomNavigationBarItem(
      // icon: Badge(label: Text("2"), child: Icon(Icons.info)),
      icon: Icon(Icons.info),
      label: '资讯',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: '我的',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    assert(_tabItems.length == _pages.length, "页面和item个数不匹配");
    return Scaffold(
      // IndexedStack 管理页面,能隐藏其他不显示页面
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory, //关闭波浪纹
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: _tabItems,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          iconSize: 24.0,
          elevation: 10.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          selectedFontSize: 14.0,
          unselectedFontSize: 12.0,
        ),
      ),
    );
  }
}

// 示例页面
class NavPage extends StatelessWidget {
  final String title;
  final Color color;

  const NavPage({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        color: color.withAlpha(50),
        child: Center(child: Text(title, style: TextStyle(fontSize: 24))),
      ),
    );
  }
}
