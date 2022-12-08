import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/input_container.dart';
import 'package:wera_f2/widgets/padding.dart';
import 'package:wera_f2/widgets/title.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class LocalController extends GetxController{
  final textController = TextEditingController();
}

class Setup extends StatelessWidget {
  Setup({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: "main",
      onPressed: _checkConnection,
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
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
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

  void _checkConnection() async {
    if (local.textController.text == "") {
      snackBar(Get.context!, PStrings.pickBackend);
      return;
    }

    loading(Get.context!);

    String backendString = "${local.textController.text}/";
    Map resp = await query(
      link: "test",
      type: RequestType.post,
      backend: backendString,
    );

    loaded(Get.context!);
    snackBar(Get.context!, resp["message"]);

    if (resp["success"]) {
      await GetStorage().write('backend', backendString);
      await GetStorage().write('setup', true);

      global.updateBackend(backendString);
      Get.back();
    }
  }
}
