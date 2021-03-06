import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:gsy_github_flutter/widget/GSYListState.dart';
import 'package:gsy_github_flutter/common/redux/GSYState.dart';
import 'package:gsy_github_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_flutter/widget/GSYPullLoadWidget.dart';
import 'package:gsy_github_flutter/widget/GSYCardItem.dart';
import 'package:gsy_github_flutter/common/utils/CommonUtils.dart';
import 'package:gsy_github_flutter/widget/ReposItem.dart';
import 'package:gsy_github_flutter/common/utils/NavigatorUtils.dart';
import 'package:gsy_github_flutter/common/dao/ReposDao.dart';

/// Create by george
/// Date:2019/2/19
/// description:主页趋势tab页
class TrendPage extends StatefulWidget {
  @override
  _TrendPageState createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage>
    with AutomaticKeepAliveClientMixin<TrendPage>, GSYListState<TrendPage> {
  static TrendTypeModel selectTime = null;

  static TrendTypeModel selectType = null;

  @override
  requestRefresh() async {
    return null;
  }

  @override
  requestLoadMore() async {
    return null;
  }

  @override
  Future<Null> handleRefresh() async {
    print('test-trendpage-isLoading:$isLoading');
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    print('test-trendpage-selectTime:$selectTime');
    await ReposDao.getTrendDao(_getStore(), since: selectTime.value, languageType: selectType.value);
    setState(() {
      pullLoadWidgetControl.needLoadMore = false;
    });
    isLoading = false;
    return null;
  }

  Store<GSYState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }

  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList = _getStore().state.trendList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      setState(() {
        selectTime = trendTime(context)[0];
        selectType = trendType(context)[0];
      });
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  bool get isRefreshFirst => false;

  _renderHeaderPopItem(String data, List<TrendTypeModel> list, PopupMenuItemSelected<TrendTypeModel> onSelected) {
    return new Expanded(
        child: new PopupMenuButton<TrendTypeModel>(
            child: new Center(
                child: new Text(data, style: GSYConstant.middleTextWhite)),
            onSelected: onSelected,
            itemBuilder: (BuildContext context) {
              return _renderHeaderPopItemChild(list);
            }));
  }

  _renderHeaderPopItemChild(List<TrendTypeModel> data) {
    List<PopupMenuEntry<TrendTypeModel>> list = new List();
    for(TrendTypeModel item in data){
      list.add(PopupMenuItem<TrendTypeModel>(
        value: item,
        child: new Text(item.name),
      ));
    }
    return list;
  }

  trendTime(BuildContext context) {
    return [
      new TrendTypeModel(CommonUtils.getLocale(context).trend_day, "daily"),
      new TrendTypeModel(CommonUtils.getLocale(context).trend_week, "weekly"),
      new TrendTypeModel(CommonUtils.getLocale(context).trend_month, "monthly"),
    ];
  }

  _renderHeader(Store<GSYState> store) {
    if (selectType == null) {
      return Container();
    }
    return new GSYCardItem(
        color: store.state.themeData.primaryColor,
        margin: EdgeInsets.all(10.0),
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: new Padding(
          padding:
              new EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
          child: new Row(
            children: <Widget>[
              _renderHeaderPopItem(selectTime.name, trendTime(context), (TrendTypeModel result) {
                if (isLoading) {
                  Fluttertoast.showToast(
                      msg: CommonUtils.getLocale(context).loading_text);
                  return;
                }
                setState(() {
                  print('test-trendpage-setState-selectTime:$selectTime');
                  selectTime = result;
                });
                showRefreshLoading();
              }),
              new Container(height: 10.0, width: 0.5, color: Color(GSYColors.white)),
              _renderHeaderPopItem(selectType.name, trendType(context), (TrendTypeModel result){
                if(isLoading){
                  Fluttertoast.showToast(msg: CommonUtils.getLocale(context).loading_text);
                  return;
                }
                setState(() {
                  selectType = result;
                });
                showRefreshLoading();
              })
            ],
          ),
        ));
  }

  _renderItem(e) {
    ReposViewModel reposViewModel = ReposViewModel.fromTrendMap(e);
    return new ReposItem(reposViewModel, onPressed: () {
      NavigatorUtils.goReposDetail(context, reposViewModel.ownerName, reposViewModel.repositoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new StoreBuilder<GSYState>(builder: (context, store) {
      return new Scaffold(
        backgroundColor: Color(GSYColors.mainBackgroundColor),
        appBar: new AppBar(
          flexibleSpace: _renderHeader(store),
          backgroundColor: Color(GSYColors.mainBackgroundColor),
          leading: new Container(),
          elevation: 0.0,
        ),
        body: GSYPullLoadWidget(
          pullLoadWidgetControl,
          (BuildContext context, int index) =>
              _renderItem(pullLoadWidgetControl.dataList[index]),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIndicatorKey,
        ),
      );
    });
  }
}

class TrendTypeModel {
  final String name;
  final String value;

  TrendTypeModel(this.name, this.value);
}


trendType(BuildContext context) {
  return [
    TrendTypeModel(CommonUtils.getLocale(context).trend_all, null),
    TrendTypeModel("Java", "Java"),
    TrendTypeModel("Kotlin", "Kotlin"),
    TrendTypeModel("Dart", "Dart"),
    TrendTypeModel("Objective-C", "Objective-C"),
    TrendTypeModel("Swift", "Swift"),
    TrendTypeModel("JavaScript", "JavaScript"),
    TrendTypeModel("PHP", "PHP"),
    TrendTypeModel("Go", "Go"),
    TrendTypeModel("C++", "C++"),
    TrendTypeModel("C", "C"),
    TrendTypeModel("HTML", "HTML"),
    TrendTypeModel("CSS", "CSS"),
  ];
}
