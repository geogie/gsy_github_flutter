import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import 'package:gsy_github_flutter/common/ab/SqlProvider.dart';
import 'package:gsy_github_flutter/common/model/Event.dart';

/// Create by george
/// Date:2019/2/20
/// description:
class UserEventDbProvider extends BaseDbProvider {
  final String name = 'UserEvent';

  final String columnId = "_id";
  final String columnUserName = "userName";
  final String columnData = "data";

  int id;
  String userName;
  String data;

  UserEventDbProvider();

  Map<String, dynamic> toMap(String userName, String eventMapString) {
    Map<String, dynamic> map = {columnUserName: userName, columnData: eventMapString};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserEventDbProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
    data = map[columnData];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnUserName text not null,
        $columnData text not null)
      ''';
  }

  @override
  tableName() {
    return name;
  }

  Future _getProvider(Database db, String userName) async {
    List<Map> maps = await db.query(name, columns: [columnId, columnData, columnUserName], where: "$columnUserName = ?", whereArgs: [userName]);
    if (maps.length > 0) {
      UserEventDbProvider provider = UserEventDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String userName, String eventMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      await db.delete(name, where: "$columnUserName = ?", whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, eventMapString));
  }

  ///获取事件数据
  Future<List<Event>> getEvents(userName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      List<Event> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Event.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
