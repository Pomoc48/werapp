import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/event.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/event.dart';
import 'package:wera_f2/widgets/drawer.dart';

void main() => runApp(EventsPage());

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

class EventsPage extends StatelessWidget {
  EventsPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => _getEvents());

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        return WillPopScope(
          onWillPop: () async => await logoutConfirm(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text(PStrings.events),
              automaticallyImplyLeading: isMobile(c),
            ),
            drawer: drawDrawer(c, const PDrawer()),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: 'main',
              onPressed: () async {
                local.controller.fadeOut();
                await Get.toNamed(Routes.newEvent);
                _getEvents();
              },
              label: Text(PStrings.newEventFAB),
              icon: const Icon(Icons.event),
            ),
            body: RefreshIndicator(
              onRefresh: () async => _getEvents(),
              child: FadeIn(
                controller: local.controller,
                child: Obx(() => _main(c, global.events)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _main(BoxConstraints constraints, List<Event>? events) {
    if (events == null) return const SizedBox();

    List<Widget> widgets = [];
    for (Event event in events) {
      widgets.add(EventCard(
        event: event,
        controller: local.controller,
        refresh: _getEvents,
      ));
    }

    return getLayout(
      constraints: constraints,
      drawer: !isMobile(constraints),
      children: widgets,
    );
  }

  Future<void> _getEvents() async {
    local.controller.fadeOut();
    Map map = await query(link: "event", type: RequestType.get);

    if (map["success"]) {
      global.updateEvents(eventListFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.controller.fadeIn();
  }
}
