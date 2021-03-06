import 'package:flutter/material.dart';

/// Create by george
/// Date:2019/2/20
/// description:
class GSYTitleBar extends StatelessWidget {
  final String title;

  final IconData iconData;

  final VoidCallback onPressed;

  final bool needRightLocalIcon;

  final Widget rightWidget;

  GSYTitleBar(this.title, {this.iconData, this.onPressed, this.needRightLocalIcon = false, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    Widget widget = rightWidget;
    if (rightWidget == null) {
      widget = (needRightLocalIcon)
          ? new IconButton(
          icon: new Icon(
            iconData,
            size: 19.0,
          ),
          onPressed: onPressed)
          : new Container();
    }
    return Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          widget
        ],
      ),
    );
  }
}
