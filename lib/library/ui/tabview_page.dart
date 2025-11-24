import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TabViewPage extends StatefulWidget {
  final List<String> tabTitles; // Tab 标题列表
  final List<Widget> tabViews;  // 对应 Tab 的页面
  final TabController? controller; // 可选的 TabController
  final Color? indicatorColor;    // 指示器颜色
  final double indicatorWeight;   // 指示器厚度
  final EdgeInsets indicatorPadding; // 指示器内边距
  final Color? labelColor;        // 选中标签颜色
  final Color? unselectedLabelColor; // 未选中标签颜色
  final TextStyle? labelStyle;    // 选中标签样式
  final TextStyle? unselectedLabelStyle; // 未选中标签样式
  final bool isScrollable;        // 是否可滚动
  final TabBarIndicatorSize? indicatorSize; // 指示器大小
  final Color? dividerColor;      // 分割线颜色
  final Decoration? tabBarDecoration; // TabBar 背景装饰
  final void Function(int index)? onTabTapped; // 添加点击回调

  const TabViewPage({
    Key? key,
    required this.tabTitles,
    required this.tabViews,
    this.controller,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.isScrollable = false,
    this.indicatorSize,
    this.dividerColor,
    this.tabBarDecoration,
    this.onTabTapped,
  })  : assert(tabTitles.length == tabViews.length, 'Tab 标题和视图数量必须一致'),
        super(key: key);

  @override
  _TabViewPageState createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = widget.controller ??
        TabController(length: widget.tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    // 如果控制器是内部创建的，则在此销毁
    if (widget.controller == null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar 部分
        Container(
          decoration: widget.tabBarDecoration,
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabTitles.map((title) => Tab(text: title)).toList(),
            isScrollable: widget.isScrollable,
            indicatorColor:
                widget.indicatorColor ?? Theme.of(context).primaryColor,
            indicatorWeight: widget.indicatorWeight,
            indicatorPadding: widget.indicatorPadding,
            labelColor: widget.labelColor ?? Theme.of(context).primaryColor,
            unselectedLabelColor:
                widget.unselectedLabelColor ?? Colors.grey[600],
            labelStyle: widget.labelStyle ??
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: widget.unselectedLabelStyle ??
                const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            indicatorSize: widget.indicatorSize ?? TabBarIndicatorSize.tab,
            dividerColor: widget.dividerColor,
            onTap: widget.onTabTapped,
          ),
        ),
        // TabBarView 部分
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );
  }
}