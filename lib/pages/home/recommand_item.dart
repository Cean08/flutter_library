import 'package:flutter/material.dart';

class RecommandItemData {
  final String title;
  final String image;
  final String date;
  final String desc;

  RecommandItemData({
    required this.title,
    required this.image,
    required this.date,
    required this.desc,
  });
}

class RecommandItem extends StatefulWidget {
  final RecommandItemData data;

  const RecommandItem(this.data, {super.key});

  @override
  State<RecommandItem> createState() => _RecommandItemState();
}

class _RecommandItemState extends State<RecommandItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Image.network(
            widget.data.image,
            width: 150.0,
            height: 120.0,
            fit: BoxFit.fitHeight,
          ),
          Padding(padding: EdgeInsets.only(left: 10.0)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.data.date),
                    Text(widget.data.desc),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
