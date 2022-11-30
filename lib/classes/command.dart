import 'package:wera_f2/server_query.dart';

class Command {
  int id;
  String name;
  int cost;
  int userId;
  DateTime updated;

  Command({
    required this.id,
    required this.name,
    required this.cost,
    required this.userId,
    required this.updated,
  });

  Future<Map> update({
    required String newName,
    required int newCost,
    required int newUserId,
  }) async {

    return await query(
      link: "command",
      type: RequestType.put,
      params: {
        "command_id": id,
        "name": newName,
        "cost": newCost,
        "user_id": newUserId,
      },
    );
  }

  Future<Map> remove() async {
    return await query(
      link: "command",
      type: RequestType.delete,
      params: {"command_id": id},
    );
  }

  factory Command.fromMap(Map data) {
    return Command(
      id: data["id"],
      name: data['name'],
      userId: data["user_id"],
      updated: DateTime.parse(data['updated']),
      cost: data['cost'],
    );
  }
}

List<Command> commandListFromList(dynamic list) {
  List<Command> dataList = [];

  for (Map element in list) {
    dataList.add(Command.fromMap(element));
  }

  return dataList;
}
