class ChartDataElement {
  int value;
  DateTime date;

  ChartDataElement({
    required this.value,
    required this.date,
  });

  factory ChartDataElement.fromMap(Map data) {
    return ChartDataElement(
      value: data["value"],
      date: DateTime.parse(data['date']),
    );
  }
}

class ChartData {
  int userId;
  List<ChartDataElement>? points;
  List<ChartDataElement>? totalPoints;

  ChartData({
    required this.userId,
    this.points,
    this.totalPoints,
  });

  factory ChartData.fromMap(Map data) {
    return ChartData(
      userId: data["user_id"],
      points: _elementsFromList(data["points"]),
      totalPoints: _elementsFromList(data["total_points"]),
    );
  }
}

List<ChartDataElement> _elementsFromList(dynamic list) {
  List<ChartDataElement> dataList = [];

  for (Map element in list) {
    dataList.add(ChartDataElement.fromMap(element));
  }

  return dataList;
}

List<ChartData> chartDataFromList(dynamic list) {
  List<ChartData> dataList = [];

  for (Map element in list) {
    dataList.add(ChartData.fromMap(element));
  }

  return dataList;
}
