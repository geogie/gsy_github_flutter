import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:gsy_github_flutter/common/model/User.dart';
import 'package:gsy_github_flutter/common/redux/GSYState.dart';
import 'package:gsy_github_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_flutter/common/utils/CommonUtils.dart';
import 'package:gsy_github_flutter/page/HomePage.dart';
import 'package:gsy_github_flutter/page/WelcomePage.dart';
import 'package:gsy_github_flutter/common/localization/GSYLocalizationsDelegate.dart';
import 'package:gsy_github_flutter/page/LoginPage.dart';
import 'package:gsy_github_flutter/common/net/Code.dart';
import 'package:gsy_github_flutter/common/event/HttpErrorEvent.dart';

void main() {
  runApp(new FlutterReduxApp());
  PaintingBinding.instance.imageCache.maximumSize = 100;// 缓存张数
}

class FlutterReduxApp extends StatelessWidget {
  // 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  // initialState 初始化 State
  final store = new Store<GSYState>(
    appReducer,
    //初始化数据
    initialState: new GSYState(
        userInfo: User.empty(),
        eventList: new List(),
        trendList: new List(),
        themeData: CommonUtils.getThemeData(GSYColors.primarySwatch),
        locale: Locale('zh', 'CH')),
  );

  @override
  Widget build(BuildContext context) {
    // 通过 StoreProvider 应用 store
    return new StoreProvider(
        store: store,
        child: new StoreBuilder<GSYState>(builder: (context, store) {
          return new MaterialApp(
            ///多语言实现代理
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GSYLocalizationsDelegate.delegate,
            ],
            locale: store.state.locale,
            supportedLocales: [store.state.locale],
            theme: store.state.themeData,
            //路由
            routes: {
              //欢迎页
              WelcomePage.sName: (context) {
                store.state.platformLocale = Localizations.localeOf(context);
                return WelcomePage();
              },
              //home页
              HomePage.sName: (context) {
                //通过 Localizations.override 包裹一层，
                return new GSYLocalizations(
                  child: new HomePage(),
                );
              },
              //登陆页
              LoginPage.sName: (context) {
                return new GSYLocalizations(
                  child: new LoginPage(),
                );
              }
            },
          );
        }));
  }
}

class GSYLocalizations extends StatefulWidget {
  final Widget child;

  GSYLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _GSYLocalizations();
  }
}

class _GSYLocalizations extends State<GSYLocalizations> {
  StreamSubscription stream;//eventbus流监听

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GSYState>(builder: (context, store) {
      //通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return new Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {// 初始化状态，类似onCreate
    super.initState();
    stream =  Code.eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {// 销毁 类似onDestory
    super.dispose();
    if(stream != null) {
      stream.cancel();
      stream = null;
    }
  }
  /// 状态码处理
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error);
        break;
      case 401:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_401);
        break;
      case 403:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_403);
        break;
      case 404:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_404);
        break;
      case Code.NETWORK_TIMEOUT://超时
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_timeout);
        break;
      default:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_unknown + " " + message);
        break;
    }
  }
}
