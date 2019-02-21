import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gsy_github_flutter/common/dao/ReposDao.dart';
import 'package:gsy_github_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_flutter/common/utils/CommonUtils.dart';
import 'package:gsy_github_flutter/widget/GSYCommonOptionWidget.dart';
import 'package:gsy_github_flutter/widget/GSYMarkdownWidget.dart';
import 'package:gsy_github_flutter/widget/GSYTitleBar.dart';


/// Create by george
/// Date:2019/2/20
/// description:
class CodeDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String path;

  final String data;

  final String title;

  final String branch;

  final String htmlUrl;

  CodeDetailPage({this.title, this.userName, this.reposName, this.path, this.data, this.branch, this.htmlUrl});

  @override
  _CodeDetailPageState createState() => _CodeDetailPageState(this.title, this.userName, this.reposName, this.path, this.data, this.branch, this.htmlUrl);
}

class _CodeDetailPageState extends State<CodeDetailPage> {
  final String userName;

  final String reposName;

  final String path;

  final String branch;

  final String htmlUrl;

  final String title;

  final OptionControl titleOptionControl = new OptionControl();

  String data;

  _CodeDetailPageState(this.title, this.userName, this.reposName, this.path, this.data, this.branch, this.htmlUrl);

  @override
  void initState() {
    super.initState();
    if (data == null) {
      ReposDao.getReposFileDirDao(userName, reposName, path: path, branch: branch, text: true).then((res) {
        if (res != null && res.result) {
          setState(() {
            data = res.data;
            titleOptionControl.url = htmlUrl ?? "";
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = (data == null)
        ? new Center(
      child: new Container(
        width: 200.0,
        height: 200.0,
        padding: new EdgeInsets.all(4.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
            new Container(width: 10.0),
            new Container(child: new Text(CommonUtils.getLocale(context).loading_text, style: GSYConstant.middleText)),
          ],
        ),
      ),
    )
        : new GSYMarkdownWidget(
      markdownData: data,
      style: GSYMarkdownWidget.DARK_LIGHT,
    );

    return new Scaffold(
      appBar: new AppBar(
        title: GSYTitleBar(
          title,
          rightWidget: new GSYCommonOptionWidget(titleOptionControl),
          needRightLocalIcon: false,
        ),
      ),
      body: widget,
    );
  }
}