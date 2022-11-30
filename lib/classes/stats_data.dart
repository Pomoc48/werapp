import 'package:wera_f2/functions.dart';

class StatsData {
  int userId;
  int totalPoints;
  int usedPoints;
  int usedCommands;
  double giftedMoney;
  int transactions;

  StatsData({
    required this.userId,
    required this.totalPoints,
    required this.usedPoints,
    required this.usedCommands,
    required this.giftedMoney,
    required this.transactions,
  });

  factory StatsData.fromMap(Map data) {
    return StatsData(
      userId: data["user_id"],
      totalPoints: data["total_points"],
      usedPoints: data["used_points"],
      usedCommands: data["used_commands"],
      giftedMoney: parseDouble(data["money_gifted"]),
      transactions: data["transactions"],
    );
  }
}

List<StatsData> statsDataListFromList(dynamic list) {
  List<StatsData> dataList = [];

  for (Map element in list) {
    dataList.add(StatsData.fromMap(element));
  }

  return dataList;
}
