import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/home_data.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/profile_avatar.dart';

class CurrentPoints extends StatelessWidget {
  const CurrentPoints({
    Key? key,
    required this.operation,
  }) : super(key: key);

  final void Function(User, bool) operation;


  @override
  Widget build(BuildContext context) {
    final GlobalController global = Get.find();
    TextStyle? primary = PStyles().primary(context).bodyLarge;

    Widget drawUserTrophy(User user) {
      List<Widget> items = [
        ProfileAvatar(userId: user.id)
      ];

      if (user.birthday) {
        items.addAll([
          const SizedBox(width: 8),
          Icon(
            Icons.cake,
            size: 20,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ]);
      }

      if (user.winner) {
        items.addAll([
          const SizedBox(width: 8),
          Icon(
            Icons.emoji_events,
            size: 20,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ]);
      }

      return Row(children: items);
    }

    Widget inkWellWrap(User user) {
      if (user.id != global.userId) {
        return InkWell(
          splashColor: PColors().inkWell(context),
          borderRadius: Settings.cardRadius,
          onTap: () => operation(user, true),
          onLongPress: () => operation(user, false),
          child: CreateCard(
            main: [
              drawUserTrophy(user),
              AnimatedFlipCounter(
                value: user.points,
                prefix: "+ ",
                textStyle: primary,
              ),
            ],
          ),
        );
      } else {
        return CreateCard(
          main: [
            drawUserTrophy(user),
            Text(user.points.toString(), style: primary),
          ],
        );
      }
    }

    Widget output(HomeData? data) {
      if (data != null) {
        List<Widget> w = [];
      
        for (int i = 0; i < data.users.length; i++) {
          if (i != data.users.length - 1) {
            w.addAll([
              inkWellWrap(data.users[i]),
              SizedBox(height: Settings.pagePadding / 2),
            ]);
          } else {
            w.add(inkWellWrap(data.users[i]));
          }
        }
      
        return Column(children: w);
      }
      return const SizedBox();
    }

    return Obx(() => output(global.homeData));
  }
}
