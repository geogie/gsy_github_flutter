import 'package:redux/redux.dart';

import 'package:gsy_github_flutter/common/model/Event.dart';

/**
 * Create by george
 * Date:2019/2/15
 * description:
 */

final EventReducer = combineReducers<List<Event>>([
  TypedReducer<List<Event>, RefreshEventAction>(_refresh),
  TypedReducer<List<Event>, LoadMoreEventAction>(_loadMore),
]);

List<Event> _refresh(List<Event> list, action) {
  list.clear();
  if (action.list == null) {
    return list;
  } else {
    list.addAll(action.list);
    return list;
  }
}

List<Event> _loadMore(List<Event> list, action) {
  if (action.list != null) {
    list.addAll(action.list);
  }
  return list;
}

class RefreshEventAction {
  final List<Event> list;

  RefreshEventAction(this.list);
}

class LoadMoreEventAction {
  final List<Event> list;

  LoadMoreEventAction(this.list);
}