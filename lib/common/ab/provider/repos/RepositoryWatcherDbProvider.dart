import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import 'package:gsy_github_flutter/common/ab/SqlProvider.dart';
import 'package:gsy_github_flutter/common/model/User.dart';
/// Create by george
/// Date:2019/2/19
/// description:
class RepositoryWatcherDbProvider extends BaseDbProvider {
  final String name = 'RepositoryWatcher';
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  RepositoryWatcherDbProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryWatcherDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnFullName text not null,
        $columnData text not null)
      ''';
  }

  @override
  tableName() {
    return name;
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps =
    await db.query(name, columns: [columnId, columnFullName, columnData], where: "$columnFullName = ?", whereArgs: [fullName]);
    if (maps.length > 0) {
      RepositoryWatcherDbProvider provider = RepositoryWatcherDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String fullName, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db.delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, dataMapString));
  }

  ///获取事件数据
  Future<List<User>> geData(String fullName) async {
    Database db = await getDataBase();

    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<User> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(User.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }

}