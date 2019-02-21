import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_flutter/common/redux/GSYState.dart';
import 'package:gsy_github_flutter/widget/GSYTabBarWidget.dart';
import 'package:gsy_github_flutter/widget/HomeDrawer.dart';
import 'package:gsy_github_flutter/common/utils/CommonUtils.dart';
import 'package:gsy_github_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_flutter/page/DynamicPage.dart';
import 'package:gsy_github_flutter/page/TrendPage.dart';
import 'package:gsy_github_flutter/page/MyPage.dart';

class HomePage extends StatelessWidget {
  static final String sName = "home";
  /// 单击提示退出
  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) =>
        new AlertDialog(
          content: new Text(CommonUtils
              .getLocale(context)
              .app_back_tip),
          actions: <Widget>[
            new FlatButton(onPressed: () => Navigator.of(context).pop(false),
                child: new Text(CommonUtils
                    .getLocale(context)
                    .app_cancel)),
            new FlatButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child: new Text(CommonUtils
                .getLocale(context)
                .app_ok
            ))
          ],
        )
    );
  }

  _renderTab(icon, text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Icon(icon, size: 16.0), new Text(text)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab(GSYICons.MAIN_DT, CommonUtils.getLocale(context).home_dynamic),
      _renderTab(GSYICons.MAIN_QS, CommonUtils.getLocale(context).home_trend),
      _renderTab(GSYICons.MAIN_MY, CommonUtils.getLocale(context).home_my),
    ];
    return WillPopScope(
      onWillPop: (){
        return _dialogExitApp(context);// 双击击返回退出应用
      },
      child: new GSYTabBarWidget(
        drawer: new HomeDrawer(),
        type: GSYTabBarWidget.BOTTOM_TAB,
        tabItems: tabs,
        tabViews: <Widget>[
          new DynamicPage(),
          new TrendPage(),
          new MyPage(),
        ],
      ),
    );
  }
}

