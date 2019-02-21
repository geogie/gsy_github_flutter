import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:gsy_github_flutter/common/ab/SqlProvider.dart';
import 'package:gsy_github_flutter/common/model/Event.dart';
/// Create by george
/// Date:2019/2/18
/// description:用户接受事件表
class ReceivedEventDbProvider extends BaseDbProvider {
  final String name = 'ReceivedEvent';

  final String columnId = "_id";
  final String columnData = "data";

  int id;
  String data;

  ReceivedEventDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnData text not null)
      ''';
  }

  ReceivedEventDbProvider.fromMap(Map map) {
    id = map[columnId];
    data = map[columnData];
  }

  ///获取事件数据
  Future<List<Event>> getEvents() async {
    Database db = await getDataBase();
    List<Map> maps = await db.query(name, columns: [columnId, columnData]);
    List<Event> list = new List();
    if (maps.length > 0) {
      ReceivedEventDbProvider provider = ReceivedEventDbProvider.fromMap(maps.first);
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Event.fromJson(item));
        }
      }
    }
    return list;
  }

  ///插入到数据库
  Future insert(String eventMapString) async {
    Database db = await getDataBase();

    ///清空后再插入，因为只保存第一页面
    db.execute("delete from $name");
    return await db.insert(name, toMap(eventMapString));
  }

  Map<String, dynamic> toMap(String eventMapString) {
    Map<String, dynamic> map = {columnData: eventMapString};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}