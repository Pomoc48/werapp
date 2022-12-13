import 'package:wera_f2/server_query.dart';

class Event {
  int id;
  int userId;
  DateTime timestamp;
  DateTime added;
  String description;

  Event({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.added,
    required this.description,
  });

  Future<Map> remove() async {
    return await query(
      link: "event",
      type: RequestType.delete,
      params: {"event_id" : id},
    );
  }

  factory Event.fromMap(Map data) {
    return Event(
      id: data["id"],
      userId: data["user_id"],
      timestamp: DateTime.parse(data['timestamp']),
      added: DateTime.parse(data['added']),
      description: data["description"],
    );
  }
}

List<Event> eventListFromList(dynamic list) {
  List<Event> dataList = [];

  for (Map element in list) {
    dataList.add(Event.fromMap(element));
  }

  return dataList;
}
