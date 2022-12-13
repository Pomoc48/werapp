import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/event.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/events/list/controller.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/event.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class EventsPage extends StatelessWidget {
  EventsPage({super.key});

  final EventsController local = EventsController();

  @override
  Widget build(BuildContext context) {
    local.pageSetup();

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: 'main',
      onPressed: () async => local.newEvent(),
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
      onRefresh: () async => local.getEvents(),
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(local.global.events),
      )),
    );
  }

  List<Widget> _main(List<Event>? events) {
    if (events == null) return [];

    List<Widget> widgets = [];
    for (Event event in events) {
      widgets.add(
        EventCard(
          event: event,
          controller: local.controller,
          refresh: local.getEvents,
        ),
      );
    }

    return widgets;
  }
}
