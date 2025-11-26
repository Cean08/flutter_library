import 'package:flutter/material.dart';
import 'package:flutter_library/library/router/app_router.dart';

class HomeRecommand extends StatelessWidget {
  const HomeRecommand({super.key});

  @override
  Widget build(BuildContext context) {

    double width = (MediaQuery.of(context).size.width-30.0)*0.5;
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      color: Color(0x11000000),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('房屋推荐'),
                TextButton(
                  onPressed: () {
                    AppRouter.push(PagePath.roomDetail);
                  },
                  child: Text('更多'),
                ),
              ],
            ),
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [1,2,3,4].map((i)=>Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
              padding: EdgeInsets.only(top: 20, bottom: 20),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(children: <Widget>[Text('家住回龙观'), Text('归属的感觉')]),
                  Image.network(
                    'https://picsum.photos/400/200?random=$i',
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
