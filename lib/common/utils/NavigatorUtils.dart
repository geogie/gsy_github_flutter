import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:gsy_github_flutter/page/CodeDetailPage.dart';
import 'package:gsy_github_flutter/page/CodeDetailPageWeb.dart';
import 'package:gsy_github_flutter/page/CommonListPage.dart';
import 'package:gsy_github_flutter/page/GSYWebView.dart';
import 'package:gsy_github_flutter/page/HomePage.dart';
import 'package:gsy_github_flutter/page/IssueDetailPage.dart';
import 'package:gsy_github_flutter/page/LoginPage.dart';
import 'package:gsy_github_flutter/page/NotifyPage.dart';
import 'package:gsy_github_flutter/page/PersonPage.dart';
import 'package:gsy_github_flutter/page/PhotoViewPage.dart';
import 'package:gsy_github_flutter/page/PushDetailPage.dart';
import 'package:gsy_github_flutter/page/ReleasePage.dart';
import 'package:gsy_github_flutter/page/RepositoryDetailPage.dart';
import 'package:gsy_github_flutter/page/SearchPage.dart';
import 'package:gsy_github_flutter/page/UserProfilePage.dart';

/// 跳转控制
class NavigatorUtils {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  ///主页
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  ///登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  ///个人中心
  static goPerson(BuildContext context, String userName) {
    NavigatorRouter(context, new PersonPage(userName));
  }

  ///仓库详情
  static Future goReposDetail(BuildContext context, String userName, String reposName) {
    return NavigatorRouter(context, RepositoryDetailPage(userName, reposName));
  }

  ///仓库版本列表
  static Future goReleasePage(BuildContext context, String userName, String reposName, String releaseUrl, String tagUrl) {
    return NavigatorRouter(
        context,
        new ReleasePage(
          userName,
          reposName,
          releaseUrl,
          tagUrl,
        ));
  }

  ///issue详情
  static Future goIssueDetail(BuildContext context, String userName, String reposName, String num, {bool needRightLocalIcon = false}) {
    return NavigatorRouter(
        context,
        new IssueDetailPage(
          userName,
          reposName,
          num,
          needHomeIcon: needRightLocalIcon,
        ));
  }

  ///通用列表
  static gotoCommonList(BuildContext context, String title, String showType, String dataType, {String userName, String reposName}) {
    NavigatorRouter(
        context,
        new CommonListPage(
          title,
          showType,
          dataType,
          userName: userName,
          reposName: reposName,
        ));
  }

  ///文件代码详情
  static gotoCodeDetailPage(BuildContext context,
      {String title, String userName, String reposName, String path, String data, String branch, String htmlUrl}) {
    NavigatorRouter(
        context,
        new CodeDetailPage(
          title: title,
          userName: userName,
          reposName: reposName,
          path: path,
          data: data,
          branch: branch,
          htmlUrl: htmlUrl,
        ));
  }

  ///仓库详情通知
  static Future goNotifyPage(BuildContext context) {
    return NavigatorRouter(context, new NotifyPage());
  }

  ///搜索
  static Future goSearchPage(BuildContext context) {
    return NavigatorRouter(context, new SearchPage());
  }

  ///提交详情
  static Future goPushDetailPage(BuildContext context, String userName, String reposName, String sha, bool needHomeIcon) {
    return NavigatorRouter(
        context,
        new PushDetailPage(
          sha,
          userName,
          reposName,
          needHomeIcon: needHomeIcon,
        ));
  }

  ///全屏Web页面
  static Future goGSYWebView(BuildContext context, String url, String title) {
    return NavigatorRouter(
        context,
        new GSYWebView(url, title)
    );
  }

  ///文件代码详情Web
  static gotoCodeDetailPageWeb(BuildContext context,
      {String title, String userName, String reposName, String path, String data, String branch, String htmlUrl}) {
    NavigatorRouter(
        context, new CodeDetailPageWeb(
      title: title,
      userName: userName,
      reposName: reposName,
      path: path,
      data: data,
      branch: branch,
      htmlUrl: htmlUrl,
    ));
  }

  ///根据平台跳转文件代码详情Web
  static gotoCodeDetailPlatform(BuildContext context,
      {String title, String userName, String reposName, String path, String data, String branch, String htmlUrl}) {
    NavigatorUtils.gotoCodeDetailPageWeb(
      context,
      title: title,
      reposName: reposName,
      userName: userName,
      path: path,
      branch: branch,
    );
  }

  ///图片预览
  static gotoPhotoViewPage(BuildContext context, String url) {
    NavigatorRouter(context, new PhotoViewPage(url));
  }

  ///用户配置
  static gotoUserProfileInfo(BuildContext context) {
    NavigatorRouter(context, new UserProfileInfo());
  }


  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context, new CupertinoPageRoute(builder: (context) => widget));
  }

}