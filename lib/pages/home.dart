import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/home_data.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/firebase_options.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/event.dart';
import 'package:wera_f2/cards/expense.dart';
import 'package:wera_f2/cards/command_log.dart';
import 'package:wera_f2/widgets/current_points.dart';
import 'package:wera_f2/widgets/drawer.dart';
import 'package:wera_f2/widgets/money_ratio.dart';
import 'package:wera_f2/widgets/title.dart';
import 'package:wera_f2/widgets/title_widget.dart';

void main() => runApp(HomePage());

class LocalController extends GetxController{
  bool _initial = true;
  final FadeInController controller = FadeInController();

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() {
      _getHome(true);
      _firebaseInit();
    });

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints c) {
      return WillPopScope(
        onWillPop: () async => await logoutConfirm(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text(PStrings.appName),
            automaticallyImplyLeading: isMobile(c),
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: "main",
            onPressed: () async {
              local.controller.fadeOut();
              await Navigator.pushNamed(context, Routes.newCommand);
              _getHome(true);
            },
            label: Text(PStrings.newCommandFAB),
            icon: const Icon(Icons.grade),
          ),
          drawer: drawDrawer(c, const PDrawer()),
          body: RefreshIndicator(
            onRefresh: () => _getHome(true),
            child: FadeIn(controller: local.controller, child: _main(c)),
          ),
        ),
      );
    });
  }

  Widget _main(BoxConstraints constraints) {
    return getLayout(
      constraints: constraints,
      drawer: !isMobile(constraints),
      welcome: Obx(() => _getTitle(global.homeData, global.userId!)),
      children: [
        TitleWidget(
          text: PStrings.currentPoints,
          child: CurrentPoints(operation: _pointOperation),
        ),
        TitleWidget(
          text: PStrings.moneyIndicator,
          child: MoneyRatio(refresh: _getHome),
        ),
        TitleWidget(
          text: PStrings.upcomingEvent,
          child: Obx(() => EventCard(
            event: global.homeData?.event,
            controller: local.controller,
            refresh: () => _getHome(true),
          )),
        ),
        TitleWidget(
          text: PStrings.recentExpense,
          child: Obx(() => ExpenseCard(
            expense: global.homeData?.expense,
            controller: local.controller,
            refresh: (() => _getHome(true)),
          )),
        ),
        TitleWidget(
          text: PStrings.recentCommandLog,
          child: Obx(() => CommandLogCard(
            cmdLog: global.homeData?.commandLog,
            controller: local.controller,
            refresh: (() => _getHome(true)),
          )),
        ),
      ],
    );
  }

  Widget _getTitle(HomeData? data, int userId) {
    if (data != null) {
      User currentUser = findUser(id: userId, userList: data.users);
      return PTitle(message: "${PStrings.welcome} ${currentUser.name}!");
    }
    return const SizedBox();
  }

  Future<void> _pointOperation(User user, bool add) async {
    Map map = add ? await user.addPoint() : await user.removePoint();

    if (map["success"]) {
      await _getHome(false);
    } else {
      snackBar(Get.context!, map["message"]);
      await _getHome(true);
    }
  }

  Future<void> _getHome(bool redraw) async {
    if (redraw) local.controller.fadeOut();

    Map map = await query(
      link: "home",
      type: RequestType.get,
      params: {"user_id": global.userId!},
    );

    if (map["success"]) {
      global.updateHomeData(getHomeDataMap(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.controller.fadeIn();
  }

  void _firebaseInit() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fcmToken;

    if (kIsWeb) {
      await messaging.requestPermission(provisional: true);
      fcmToken = await messaging.getToken(vapidKey: global.vapid!);
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      await FlutterNotificationChannel.registerNotificationChannel(
        name: 'Main',
        description: 'Event updates',
        id: 'updates',
        importance: NotificationImportance.IMPORTANCE_HIGH,
      );

      fcmToken = await messaging.getToken();
    }

    if (fcmToken != null) {
      await query(
        link: "fcm-token",
        type: RequestType.post,
        params: {
          "user_id": global.userId!,
          "fcm_token": fcmToken,
        }
      );
    }
  }
}
