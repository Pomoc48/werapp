import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/setup/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/title.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class Setup extends StatelessWidget {
  Setup({super.key});

  final SetupController local = SetupController();

  @override
  Widget build(BuildContext context) {

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: local.checkConnection,
      label: Text(PStrings.checkConn),
      icon: const Icon(Icons.wifi_find),
    );

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: PLayout(
        title: PStrings.setup,
        backArrow: false,
        fab: fab,
        child: WidgetFromList(
          contextWidth: context.width,
          forceSingle: true,
          children: [
            PTitle(message: PStrings.appSetupThing),
            PPadding(widget: Text(PStrings.appSetupMessage)),
            InputContainer(
              widget: TextField(
                controller: local.textController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  enabledBorder: Settings.noBorder,
                  focusedBorder: Settings.noBorder,
                  hintText: PStrings.backendUrlHint,
                  labelText: PStrings.backendUrl
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
