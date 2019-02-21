import 'package:redux/redux.dart';
import 'package:gsy_github_flutter/common/model/TrendingRepoModel.dart';
/**
 * Create by george
 * Date:2019/2/18
 * description:事件Redux
 */
final TrendReducer = combineReducers<List<TrendingRepoModel>>([
  TypedReducer<List<TrendingRepoModel>, RefreshTrendAction>(_refresh),
]);

List<TrendingRepoModel> _refresh(List<TrendingRepoModel> list, action) {
  list.clear();
  if (action.list == null) {
    return list;
  } else {
    list.addAll(action.list);
    return list;
  }
}

class RefreshTrendAction {
  final List<TrendingRepoModel> list;

  RefreshTrendAction(this.list);
}