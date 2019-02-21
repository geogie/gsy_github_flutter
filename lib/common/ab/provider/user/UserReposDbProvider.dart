import 'dart:convert';

import 'package:gsy_github_flutter/common/ab/SqlProvider.dart';
import 'package:gsy_github_flutter/common/model/Repository.dart';
import 'package:sqflite/sqflite.dart';
/// Create by george
/// Date:2019/2/19
/// description:
class UserReposDbProvider extends BaseDbProvider {
  final String name = 'UserRepos';

  final String columnId = "_id";
  final String columnUserName = "userName";
  final String columnData = "data";

  int id;
  String userName;
  String data;

  UserReposDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnUserName text not null,
        $columnData text not null)
      ''';
  }

  ///插入到数据库
  Future insert(String userName, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      await db.delete(name, where: "$columnUserName = ?", whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, dataMapString));
  }

  Future _getProvider(Database db, String userName) async {
    List<Map<String, dynamic>> maps =
    await db.query(name, columns: [columnId, columnUserName, columnData], where: "$columnUserName = ?", whereArgs: [userName]);
    if (maps.length > 0) {
      UserReposDbProvider provider = UserReposDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnUserName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserReposDbProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
    data = map[columnData];
  }
  ///获取事件数据
  Future<List<Repository>> geData(String userName) async {
    Database db = await getDataBase();

    var provider = await _getProvider(db, userName);
    if (provider != null) {
      List<Repository> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Repository.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}