import 'package:wera_f2/functions.dart';
import 'package:wera_f2/server_query.dart';

class Expense {
  int id;
  double money;
  DateTime timestamp;
  int userId;
  int recipientId;
  bool gift;
  String? description;
  bool accepted;

  Expense({
    required this.id,
    required this.money,
    required this.timestamp,
    required this.userId,
    required this.recipientId,
    required this.gift,
    required this.accepted,
    this.description,
  });

  Future<Map> verify() async {
    return await query(
      link: "expense",
      type: RequestType.patch,
      params: {"expense_id": id},
    );
  }

  Future<Map> remove() async {
    return await query(
      link: "expense",
      type: RequestType.delete,
      params: {"expense_id": id},
    );
  }

  factory Expense.fromMap(Map data) {
    return Expense(
      id: data["id"],
      timestamp: DateTime.parse(data['timestamp']),
      money: parseDouble(data['money']),
      userId: data["user_id"],
      recipientId: data["recipient_id"],
      gift: data["gift"],
      description: data['description'],
      accepted: data["accepted"],
    );
  }
}

List<Expense> expenseListFromList(dynamic list) {
  List<Expense> dataList = [];

  for (Map element in list) {
    dataList.add(Expense.fromMap(element));
  }

  return dataList;
}
