import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_flutter/common/dao/UserDao.dart';
import 'package:gsy_github_flutter/common/redux/GSYState.dart';
import 'package:gsy_github_flutter/common/utils/CommonUtils.dart';
import 'package:gsy_github_flutter/common/utils/NavigatorUtils.dart';
import 'package:redux/redux.dart';
/// 欢迎页
class WelcomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    ///防止多次进入
    Store<GSYState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);
    new Future.delayed(const Duration(seconds: 2), () {// 2s后跳转
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.goHome(context);// 跳转home页
        } else {
          NavigatorUtils.goLogin(context);// 跳转login页
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        return new Container(
          child: new Center(
            child:
                new Image(image: new AssetImage('static/images/welcome.png')),
          ),
        );
      },
    );
  }
}
