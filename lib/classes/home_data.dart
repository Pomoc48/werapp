import 'package:wera_f2/classes/command_log.dart';
import 'package:wera_f2/classes/event.dart';
import 'package:wera_f2/classes/expense.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';

class HomeData {
  List<User> users;
  Event? event;
  List<MoneyMeter> meters;
  Expense? expense;
  CommandLog? commandLog;
  int? pending;

  HomeData({
    required this.users,
    this.event,
    required this.meters,
    this.expense,
    this.commandLog,
    this.pending,
  });
}

class MoneyMeter {
  int userId;
  bool tie;
  int? winnerId;
  double moneyLeft;
  double factor;

  MoneyMeter({
    required this.userId,
    required this.tie,
    this.winnerId,
    this.moneyLeft = 0,
    this.factor = 0,
  });

  factory MoneyMeter.fromMap(Map data) {
    int userId = data["user_id"];
    bool tie = data["tie"];

    if (tie) return MoneyMeter(tie: tie, userId: userId);

    return MoneyMeter(
      userId: userId,
      tie: tie,
      winnerId: data["winner_id"],
      moneyLeft: parseDouble(data['money_left']),
      factor: parseDouble(data['factor']),
    );
  }
}

HomeData getHomeDataMap(dynamic data) {

  List<User> convertList(List list) {
    List<User> outputList = [];

    for (Map element in list) {
      outputList.add(User.fromMap(element));
    }

    return outputList;
  }

  List<MoneyMeter> moneyMetersFromList(dynamic list) {
    List<MoneyMeter> dataList = [];

    for (Map element in list) {
      dataList.add(MoneyMeter.fromMap(element));
    }

    return dataList;
  }

  Event? event;
  if (data["event"] is Map) {
    event = Event.fromMap(data["event"]);
  }

  Expense? expense;
  if (data["expense"] is Map) {
    expense = Expense.fromMap(data["expense"]);
  }

  CommandLog? commandLog;
  if (data["command_log"] is Map) {
    commandLog = CommandLog.fromMap(data["command_log"]);
  }

  return HomeData(
    users: convertList(data["users"]),
    event: event,
    meters: moneyMetersFromList(data["meters"]),
    expense: expense,
    commandLog: commandLog,
    pending: data["pending"]["expenses"],
  );
}