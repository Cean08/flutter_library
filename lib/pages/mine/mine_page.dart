import 'package:flutter/material.dart';
import 'package:flutter_library/widgets/page_content.dart';
import 'package:provider/provider.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RadioModel(),
      child: DefaultTabController(
        length: 2,
        // animationDuration: Duration(seconds: 2),
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: Text(
                '发布房源',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          appBar: AppBar(
            elevation: 0, //导航下面的分割线
            title: Text(
              '我的',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            surfaceTintColor: Colors.white,
            bottom: TabBar(tabs: [Text("左边"), Text("右边")]),
          ),
          body: TabBarView(
            children: [
              Consumer<RadioModel>(
                builder: (context, radioModel, child) {
                  return Column(
                    children: [
                      Text("111"),
                      Text("111"),
                      Text("111"),
                      Text("111"),
                      Radio(
                        value: 'option1',
                        groupValue: radioModel.selectedValue,
                        onChanged: (value) {
                          radioModel.setSelectedValue(value!);
                        },
                      ),
                      Radio(
                        value: 'option2',
                        groupValue: radioModel.selectedValue,
                        onChanged: (value) {
                          radioModel.setSelectedValue(value!);
                        },
                      ),
                      Radio(
                        value: 'option3',
                        groupValue: radioModel.selectedValue,
                        onChanged: (value) {
                          radioModel.setSelectedValue(value!);
                        },
                      ),
                    ],
                  );
                },
              ),
              Column(
                children: [Text("222"), Text("222"), Text("222"), Text("222")],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioModel with ChangeNotifier {
  String _selectedValue = 'option1';

  String get selectedValue => _selectedValue;

  void setSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }
}
