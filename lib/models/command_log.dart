import 'package:wera_f2/server_query.dart';

class CommandLog {
  int id;
  int userId;
  String commandName;
  String description;
  DateTime timestamp;
  int cost;
  int recipientId;
  bool reported;

  CommandLog({
    required this.id,
    required this.userId,
    required this.commandName,
    required this.description,
    required this.timestamp,
    required this.cost,
    required this.recipientId,
    required this.reported,
  });

  Future<Map> report() async {
    return await query(
      link: "command-log",
      type: RequestType.patch,
      params: {"command_log_id": id},
    );
  }

  factory CommandLog.fromMap(Map data) {
    return CommandLog(
      id: data["id"],
      timestamp: DateTime.parse(data['timestamp']),
      description: data["description"],
      commandName: data["command_name"],
      userId: data["user_id"],
      cost: data["cost"],
      recipientId: data["recipient_id"],
      reported: data["reported"],
    );
  }
}

List<CommandLog> cmdLogListFromList(dynamic list) {
  List<CommandLog> dataList = [];

  for (Map element in list) {
    dataList.add(CommandLog.fromMap(element));
  }

  return dataList;
}