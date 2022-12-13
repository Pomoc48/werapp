import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/event.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/profile_avatar.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
    required this.refresh,
    required this.controller,
  }) : super(key: key);

  final void Function() refresh;
  final FadeInController controller;
  final Event? event;

  @override
  Widget build(BuildContext context) {
    Widget drawEvent(Event e) {
      return InkWell(
        splashColor: PColors().inkWell(context),
        borderRadius: Settings.cardRadius,
        onTap: () async {
          controller.fadeOut();
          await Get.toNamed(Routes.detailEvent, arguments: {"event": event});
          refresh();
        },
        child: CreateCard(
          main: [ProfileAvatar(userId: e.userId, timestamp: e.added)],
          cont: [formatDate(e.timestamp), e.description],
        ),
      );
    }

    Widget output() {
      if (event == null) {
        return InkWell(
          splashColor: PColors().inkWell(context),
          borderRadius: Settings.cardRadius,
          onTap: () async {
            controller.fadeOut();
            await Get.toNamed(Routes.newEvent);
            refresh();
          },
          child: CreateCard(
            main: [PStrings.noUpcomingEvents],
            cont: [PStrings.newEventTitle],
          ),
        );
      }

      return drawEvent(event!);
    }

    return output();
  }
}
