import 'package:wera_f2/server_query.dart';

class User {
  int id;
  String name;
  String? profileUrl;
  int points;
  bool winner;
  bool birthday;

  User({
    required this.id,
    required this.name,
    required this.profileUrl,
    this.points = 0,
    this.winner = false,
    this.birthday = false,
  });

  Future<Map> addPoint() async {
    return await query(
      link: "point",
      type: RequestType.post,
      params: {"user_id": id},
    );
  }

  Future<Map> removePoint() async {
    return await query(
      link: "point",
      type: RequestType.delete,
      params: {"user_id": id},
    );
  }

  factory User.fromMap(Map data) {
    if (data["points"] == null) {
      return User(
        id: data["id"],
        name: data["name"],
        profileUrl: data["profile_url"],
      );
    }

    return User(
      id: data["id"],
      name: data["name"],
      profileUrl: data["profile_url"],
      points: data['points'],
      winner: data["winner"],
      birthday: data["birthday"],
    );
  }
}

List<User> userListFromList(dynamic list) {
  List<User> dataList = [];

  for (Map element in list) {
    dataList.add(User.fromMap(element));
  }

  return dataList;
}
