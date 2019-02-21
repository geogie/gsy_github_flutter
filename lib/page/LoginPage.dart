import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:gsy_github_flutter/common/redux/GSYState.dart';
import 'package:gsy_github_flutter/common/local/LocalStorage.dart';
import 'package:gsy_github_flutter/common/config/Config.dart';
import 'package:gsy_github_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_flutter/widget/GSYInputWidget.dart';
import 'package:gsy_github_flutter/common/utils/CommonUtils.dart';
import 'package:gsy_github_flutter/widget/GSYFlexButton.dart';
import 'package:gsy_github_flutter/common/dao/UserDao.dart';
import 'package:gsy_github_flutter/common/utils/NavigatorUtils.dart';
///登陆页
class LoginPage extends StatefulWidget {
  static final String sName = "login";

  @override
  State createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var _userName = "";
  var _password = "";
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();

  _LoginPageState() : super();

  @override
  void initState() {
    super.initState();
    initParams();
  }

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwController.value = new TextEditingValue(text: _password ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GSYState>(builder: (context, store) {
      return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: new Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              //防止overFlow的现象
              child: SafeArea(
                  child: new Card(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                color: Color(GSYColors.cardWhite),
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: new Padding(
                    padding: new EdgeInsets.only(
                        left: 30.0, top: 40.0, right: 30.0, bottom: 0.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // icon
                      new Image(image: new AssetImage(GSYICons.DEFAULT_USER_ICON),width: 90.0, height: 90.0),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      // 用户名
                      new GSYInputWidget(
                        hintText: CommonUtils.getLocale(context).login_username_hint_text,
                        iconData: GSYICons.LOGIN_USER,
                        onChanged: (String value) {
                          _userName = value;
                        },
                        controller: userController,
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      // 密码
                      new GSYInputWidget(
                        hintText: CommonUtils.getLocale(context).login_password_hint_text,
                        iconData: GSYICons.LOGIN_PW,
                        obscureText: true,
                        onChanged: (String value) {
                          _password = value;
                        },
                        controller: pwController,
                      ),
                      new Padding(padding: new EdgeInsets.all(30.0)),
                      // button login
                      new GSYFlexButton(
                        text: CommonUtils.getLocale(context).login_text,
                        color: Theme.of(context).primaryColor,
                        textColor: Color(GSYColors.textWhite),
                        onPress: (){
                          if (_userName == null || _userName.length == 0) {
                            Fluttertoast.showToast(msg: CommonUtils.getLocale(context).login_no_name_or_pass);
                            return;
                          }
                          if (_password == null || _password.length == 0) {
                            Fluttertoast.showToast(msg: CommonUtils.getLocale(context).login_no_name_or_pass);
                            return;
                          }
                          CommonUtils.showLoadingDialog(context);
                          UserDao.login(_userName.trim(), _password.trim(), store).then((res){
                            Navigator.pop(context);
                            if (res != null && res.result) {
                              new Future.delayed(const Duration(seconds: 1), () {
                                NavigatorUtils.goHome(context);
                                return true;
                              });
                            }
                          });
                        },
                      ),
                      new Padding(padding: new EdgeInsets.all(30.0))
                    ],
                  ),
                ),

              )),
            ),
          ),
        ),
      );
    });
  }
}
