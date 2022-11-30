import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/divider.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/profile_avatar.dart';

class CreateCard extends StatelessWidget {
  const CreateCard({
    Key? key,
    required this.main,
    this.cont,
  }) : super(key: key);

  final dynamic main;
  final dynamic cont;

  @override
  Widget build(BuildContext context) {
    TextStyle? bodyLarge = PStyles().onSurface(context).bodyLarge;
    TextStyle? primary = PStyles().primary(context).bodyLarge;

    List<Widget> w = [];

    if (main is String) {
      w.add(PPadding(widget: Text(main, style: bodyLarge)));
    }

    if (main is List<String>) {
      List<Widget> wRow = [
        Expanded(child: PPadding(widget: Text(main[0], style: bodyLarge))),
      ];

      if (main.length > 1) {
        wRow.add(PPadding(widget: Text(main[1], style: primary)));
      }

      w.add(Row(children: wRow));
    }

    if (main is Widget) {
      if (main is ProfileAvatar) {
        w.add(PPadding(widget: main));
      } else {
        w.add(Expanded(child: PPadding(widget: main)));
      }
      
    }

    if (main is List<Widget>) {
      List<Widget> wRow = [
        Expanded(child: PPadding(widget: main[0])),
      ];

      if (main.length > 1) {
        if (main[1] is! PopupMenuButton &&
            main[1] is! IconButton &&
            main[1] is! Obx) {
          wRow.add(PPadding(widget: main[1]));
        } else {
          wRow.add(Padding(
            padding: EdgeInsets.only(right: Settings.pagePadding / 2),
            child: main[1],
          ));
        }
      }

      w.add(Row(children: wRow));
    }

    if (cont is String) {
      w.add(PDivider(indent: Settings.pagePadding));
      w.add(PPadding(widget: Text(main, style: bodyLarge)));
    }

    if (cont is List<String>) {
      w.add(PDivider(indent: Settings.pagePadding));

      List<Widget> cWidgets = [];

      for (int i = 0; i < cont.length; i++) {
        if (i != 0) {
          cWidgets.add(Text(
            cont[i],
            style: PStyles().onSurface(context).bodyMedium,
          ));
        } else {
          cWidgets.add(
            Text(
              cont[i],
              style: Get.textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary),
            ),
          );
        }

        if (i != cont.length - 1) {
          cWidgets.add(SizedBox(height: Settings.pagePadding / 1.5));
        }
      }

      w.add(
        PPadding(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cWidgets,
          ),
        ),
      );
    }

    if (cont is Widget) {
      if (cont is LinearProgressIndicator) {
        w.add(Padding(
          padding: EdgeInsets.only(
            left: Settings.pagePadding,
            right: Settings.pagePadding,
            bottom: Settings.pagePadding,
          ),
          child: cont,
        ));
      } else {
        w.add(PDivider(indent: Settings.pagePadding));
        w.add(PPadding(widget: cont));
      }
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: w,
      ),
    );
  }
}
