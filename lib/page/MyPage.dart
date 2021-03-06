import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:gsy_github_flutter/widget/BasePersonState.dart';
import 'package:gsy_github_flutter/common/redux/GSYState.dart';
import 'package:gsy_github_flutter/widget/GSYPullLoadWidget.dart';
import 'package:gsy_github_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_flutter/common/dao/UserDao.dart';
import 'package:gsy_github_flutter/common/dao/EventDao.dart';
import 'package:gsy_github_flutter/common/redux/UserRedux.dart';
import 'package:gsy_github_flutter/common/dao/ReposDao.dart';

/// Create by george
/// Date:2019/2/20
/// description:主页我的tab页
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends BasePersonState<MyPage> {
  String beStaredCount = '---';
  Color notifyColor = const Color(GSYColors.subTextColor);
  Store<GSYState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of(context);
  }

  _getUserName() {
    if (_getStore()?.state?.userInfo == null) {
      return null;
    }
    print('test-MyPage-userInfo:${_getStore()?.state?.userInfo}');
    return _getStore()?.state?.userInfo?.login;
  }

  @override
  requestRefresh() async {
    if (_getUserName() != null) {
      UserDao.getUserInfo(null).then((res) {
        if (res != null && res.result) {
          _getStore()?.dispatch(UpdateUserAction(res.data));
          getUserOrg(_getUserName());
        }
      });
      ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
        if (res != null && res.result) {
          if (isShow) {
            setState(() {
              beStaredCount = res.data.toString();
            });
          }
        }
      });
      _refreshNotify();
    }
    print('test-MyPage-res');
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  _getDataLogic() async {
    if (_getUserName() == null) {
      return [];
    }
    if (getUserType() == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    return await EventDao.getEventDao(_getUserName(), page: page, needDb: page <= 1);
  }

  getUserType() {
    if (_getStore()?.state?.userInfo == null) {
      return null;
    }
    return _getStore()?.state?.userInfo?.type;
  }

  _refreshNotify() {
    UserDao.getNotifyDao(false, false, 0).then((res) {
      Color newColor;
      if (res != null && res.result && res.data.length > 0) {
        newColor = Color(GSYColors.actionBlue);
      } else {
        newColor = Color(GSYColors.subLightTextColor);
      }
      if (isShow) {
        setState(() {
          notifyColor = newColor;
        });
      }
    });
  }

  @override
  bool get isRefreshFirst => false;

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => true;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new StoreBuilder<GSYState>(
      builder: (context, store) {
        return GSYPullLoadWidget(
          pullLoadWidgetControl,
              (BuildContext context, int index) => renderItem(index, store.state.userInfo, beStaredCount, notifyColor, () {
            _refreshNotify();
          }, orgList),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIndicatorKey,
        );
      },
    );
  }
}