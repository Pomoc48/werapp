import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/event.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/event.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

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

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: 'main',
      onPressed: () async {
        local.controller.fadeOut();
        await Get.toNamed(Routes.newEvent);
        _getEvents();
      },
      label: Text(PStrings.newEventFAB),
      icon: const Icon(Icons.event),
    );

    return PLayout(
      title: PStrings.events,
      drawer: true,
      fab: fab,
      logoutConfirm: true,
      scrollable: true,
      fadeController: local.controller,
      onRefresh: () async => _getEvents(),
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(global.events),
      )),
    );
  }

  List<Widget> _main(List<Event>? events) {
    if (events == null) return [];

    List<Widget> widgets = [];
    for (Event event in events) {
      widgets.add(EventCard(
        event: event,
        controller: local.controller,
        refresh: _getEvents,
      ));
    }

    return widgets;
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
