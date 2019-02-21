import 'package:flutter/material.dart';

import 'package:gsy_github_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_flutter/widget/GSYCardItem.dart';
import 'package:gsy_github_flutter/common/model/User.dart';
import 'package:gsy_github_flutter/common/model/UserOrg.dart';

/// Create by george
/// Date:2019/2/20
/// description:
class UserItem extends StatelessWidget {
  final UserItemViewModel userItemViewModel;

  final VoidCallback onPressed;

  final bool needImage;

  UserItem(this.userItemViewModel, {this.onPressed, this.needImage = true}) : super();
  @override
  Widget build(BuildContext context) {
    Widget userImage = new IconButton(
        padding: EdgeInsets.only(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0),
        icon: new ClipOval(
          child: new FadeInImage.assetNetwork(
            placeholder: GSYICons.DEFAULT_USER_ICON,
            //预览图
            fit: BoxFit.fitWidth,
            image: userItemViewModel.userPic,
            width: 30.0,
            height: 30.0,
          ),
        ),
        onPressed: null);
    return new Container(
        child: new GSYCardItem(
          child: new FlatButton(
            onPressed: onPressed,
            child: new Padding(
              padding: new EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 10.0),
              child: new Row(
                children: <Widget>[
                  userImage,
                  new Expanded(child: new Text(userItemViewModel.userName, style: GSYConstant.smallTextBold)),
                ],
              ),
            ),
          ),
        ));
  }
}

class UserItemViewModel {
  String userPic;
  String userName;

  UserItemViewModel.fromMap(User user) {
    userName = user.login;
    userPic = user.avatar_url;
  }

  UserItemViewModel.fromOrgMap(UserOrg org) {
    userName = org.login;
    userPic = org.avatarUrl;
  }
}