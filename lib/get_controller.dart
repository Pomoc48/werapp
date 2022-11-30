import 'package:get/get.dart';
import 'package:wera_f2/classes/chart_data.dart';
import 'package:wera_f2/classes/command.dart';
import 'package:wera_f2/classes/command_log.dart';
import 'package:wera_f2/classes/event.dart';
import 'package:wera_f2/classes/expense.dart';
import 'package:wera_f2/classes/home_data.dart';
import 'package:wera_f2/classes/stats_data.dart';
import 'package:wera_f2/classes/user.dart';

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

  List<User>? get users => _users.value;
  HomeData? get homeData => _homeData.value;
  List<CommandLog>? get commandsLog => _commandsLog.value;
  List<Expense>? get expenses => _expenses.value;
  List<Command>? get commands => _commands.value;
  List<Event>? get events => _events.value;
  List<StatsData>? get stats => _stats.value;
  List<ChartData>? get charts => _chart.value;

  updateToken(String newToken) => token = newToken;
  updateVapid(String newVapid) => vapid = newVapid;
  updateBackend(String newBackend) => backend = newBackend;
  updateUserId(int newId) => userId = newId;
  
  updateUsers(List<User>? newData) => _users.value = newData;
  updateHomeData(HomeData? newData) => _homeData.value = newData;
  updateCmdLog(List<CommandLog>? newData) => _commandsLog.value = newData;
  updateCommands(List<Command>? newData) => _commands.value = newData;
  updateEvents(List<Event>? newData) => _events.value = newData;
  updateStats(List<StatsData>? newData) => _stats.value = newData;
  updateCharts(List<ChartData>? newData) => _chart.value = newData;
  updateExpenses(List<Expense>? newData) => _expenses.value = newData;
  updatePending(int newInt) => _homeData.value?.pending = newInt;
}