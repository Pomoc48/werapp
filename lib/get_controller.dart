import 'package:get/get.dart';
import 'package:wera_f2/models/chart_data.dart';
import 'package:wera_f2/models/command.dart';
import 'package:wera_f2/models/command_log.dart';
import 'package:wera_f2/models/event.dart';
import 'package:wera_f2/models/expense.dart';
import 'package:wera_f2/models/home_data.dart';
import 'package:wera_f2/models/stats_data.dart';
import 'package:wera_f2/models/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/server_query.dart';

class GlobalController extends GetxController{
  String? backend;
  String? token;
  String? vapid;
  int? userId;

  final _users = Rx<List<User>?>(null);
  final _homeData = Rx<HomeData?>(null);
  final _commandsLog = Rx<List<CommandLog>?>(null);
  final _expenses = Rx<List<Expense>?>(null);
  final _commands = Rx<List<Command>?>(null);
  final _events = Rx<List<Event>?>(null);
  final _stats = Rx<List<StatsData>?>(null);
  final _chart = Rx<List<ChartData>?>(null);

  void updateBackend(String newBackend) => backend = newBackend;
  void updatePending(int newInt) => _homeData.value?.pending = newInt;

  List<User>? get users => _users.value;
  HomeData? get homeData => _homeData.value;
  List<ChartData>? get charts => _chart.value;
  List<StatsData>? get stats => _stats.value;
  List<Event>? get events => _events.value;
  List<CommandLog>? get commandsLog => _commandsLog.value;
  List<Command>? get commands => _commands.value;
  List<Expense>? get expenses => _expenses.value;

  void updateLoginValues({
    required String newToken,
    required String newVapid,
    required int newId,
  }) {
    token = newToken;
    vapid = newVapid;
    userId = newId;
  }

  void updateUsers() async {
    _users.value = null;
    Map map = await query(link: "user", type: RequestType.get);
    _check(map, () => _users.value = userListFromList(map["data"]));
  }

  void updateHomeData() async {
    Map map = await query(
      link: "home",
      type: RequestType.get,
      params: {"user_id": userId!},
    );

    _check(map, () => _homeData.value = getHomeDataMap(map["data"]));
  }

  void pointOperation(User user, bool add) async {
    Map map = add ? await user.addPoint() : await user.removePoint();
    _check(map, () => updateHomeData());
  }

  void updateCharts() async {
    Map map = await query(link: "chart", type: RequestType.get);
    _check(map, () => _chart.value = chartDataFromList(map["data"]));
  }

  void updateStats() async {
    Map map = await query(link: "stats", type: RequestType.get);
    _check(map, () => _stats.value = statsDataListFromList(map["data"]));
  }

  void updateEvents() async {
    Map map = await query(link: "event", type: RequestType.get);
    _check(map, () => _events.value = eventListFromList(map["data"]));
  }

  void updateCommandLogs() async {
    Map map = await query(link: "command-log", type: RequestType.get);
    _check(map, () => _commandsLog.value = cmdLogListFromList(map["data"]));
  }

  void updateCommands() async {
    Map map = await query(link: "command", type: RequestType.get);
    _check(map, () => _commands.value = commandListFromList(map["data"]));
  }

  void updateExpenses() async {
    Map map = await query(link: "expense", type: RequestType.get);
    _check(map, () => _expenses.value = expenseListFromList(map["data"]));
  }

  void _check(Map map, dynamic Function() fun) {
    if (map["success"]) {
      fun();
    } else {
      snackBar(Get.context!, map["message"]);
    }
  }
}