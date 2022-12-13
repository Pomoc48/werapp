import 'package:get/get.dart';
import 'package:wera_f2/classes/chart_data.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/classes/command_log.dart';
import 'package:wera_f2/classes/event.dart';
import 'package:wera_f2/classes/expense.dart';
import 'package:wera_f2/classes/home_data.dart';
import 'package:wera_f2/classes/stats_data.dart';
import 'package:wera_f2/classes/user.dart';
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

  List<CommandLog>? get commandsLog => _commandsLog.value;
  List<Expense>? get expenses => _expenses.value;
  List<Command>? get commands => _commands.value;

  updateBackend(String newBackend) => backend = newBackend;

  // LOGIN
  List<User>? get users => _users.value;

  updateLoginValues({
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

    if (map["success"]) {
      _users.value = userListFromList(map["data"]);
    } else {
      snackBar(Get.context!, map["message"]);
    }
  }

  // HOME
  HomeData? get homeData => _homeData.value;

  void updateHomeData() async {
    Map map = await query(
      link: "home",
      type: RequestType.get,
      params: {"user_id": userId!},
    );

    if (map["success"]) {
      _homeData.value = getHomeDataMap(map["data"]);
    } else {
      snackBar(Get.context!, map["message"]);
    }
  }

  void pointOperation(User user, bool add) async {
    Map map = add ? await user.addPoint() : await user.removePoint();

    if (map["success"]) {
      updateHomeData();
    } else {
      snackBar(Get.context!, map["message"]);
    }
  }

  // CHARTS
  List<ChartData>? get charts => _chart.value;

  void updateCharts() async {
    Map map = await query(link: "chart", type: RequestType.get);

    if (map["success"]) {
      _chart.value = chartDataFromList(map["data"]);
    } else {
      snackBar(Get.context!, map["message"]);
    }
  }

  // STATS
  List<StatsData>? get stats => _stats.value;

  void updateStats() async {
    Map map = await query(link: "stats", type: RequestType.get);

    if (map["success"]) {
      _stats.value = statsDataListFromList(map["data"]);
    } else {
      snackBar(Get.context!, map["message"]);
    }
  }

  // EVENTS
  List<Event>? get events => _events.value;

  void updateEvents() async {
    Map map = await query(link: "event", type: RequestType.get);

    if (map["success"]) {
      _events.value = eventListFromList(map["data"]);
    } else {
      snackBar(Get.context!, map["message"]);
    }
  }

  updateCmdLog(List<CommandLog>? newData) => _commandsLog.value = newData;
  updateCommands(List<Command>? newData) => _commands.value = newData;
  updateExpenses(List<Expense>? newData) => _expenses.value = newData;
  updatePending(int newInt) => _homeData.value?.pending = newInt;
}