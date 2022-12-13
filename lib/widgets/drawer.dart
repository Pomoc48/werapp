import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/divider.dart';
import 'package:wera_f2/widgets/padding.dart';

class PDrawer extends StatelessWidget {
  const PDrawer({super.key, this.fab, this.mobile = false});

  final Widget? fab;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final GlobalController global = Get.find();

    Widget listTile({
      required IconData iconData,
      required String label,
      required String path,
      int? badges,
    }) {
      Color backgroundColor = Colors.transparent;
      if (path == Get.currentRoute) {
        backgroundColor = Theme.of(context).colorScheme.surfaceTint
            .withOpacity(0.14);
      }

      TextStyle? drawerLabel(BuildContext context) {
        return Theme.of(context).textTheme.apply(
            bodyColor: PColors().onSecondaryC(context)).labelLarge;
      }

      List<Widget> drawItems() {
        if (badges != null && badges > 0) {
          return [
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: Settings.pagePadding),
                  Icon(iconData, color: PColors().onSecondaryC(context)),
                  SizedBox(width: Settings.pagePadding),
                  Text(label, style: drawerLabel(context)),
                ],
              ),
            ),
            Text(
              badges.toString(),
              style: Get.textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: 24),
          ];
        }
        return [
          SizedBox(width: Settings.pagePadding),
          Icon(iconData, color: PColors().onSecondaryC(context)),
          SizedBox(width: Settings.pagePadding),
          Text(label, style: drawerLabel(context)),
        ];
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: InkWell(
          borderRadius: Settings.fullRadius,
          onTap: () async {
            if (path == Routes.login) {
              Get.offAllNamed(Routes.login);
            } else {
              if (Get.currentRoute == path) {
                Scaffold.of(context).closeDrawer();
              } else {
                Get.offNamed(path);
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: Settings.fullRadius,
              color: backgroundColor,
            ),
            height: mobile ? 56 : 48,
            child: Row(children: drawItems()),
          ),
        ),
      );
    }

    Padding listSection(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Text(title, style: Get.textTheme.titleSmall),
      );
    }

    Widget fabButton() {
      if (fab != null) return PPadding(widget: fab!);
      return const SizedBox();
    }

    double marginSize = Settings.pagePadding;
    if (mobile) marginSize = marginSize * 2;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fabButton(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: marginSize),
                listSection("Main"),
                listTile(
                  iconData: Icons.home,
                  label: PStrings.home,
                  path: Routes.home,
                ),
                listTile(
                  iconData: Icons.grade,
                  label: PStrings.commandsLog,
                  path: Routes.commandsLog,
                ),
                listTile(
                  iconData: Icons.account_balance_wallet,
                  label: PStrings.expenses,
                  path: Routes.expenses,
                  badges: global.homeData?.pending,
                ),
                listTile(
                  iconData: Icons.event,
                  label: PStrings.events,
                  path: Routes.events,
                ),
                PDivider(indent: 28, height: Settings.pagePadding),
                listSection("Insights"),
                listTile(
                  iconData: Icons.leaderboard,
                  label: PStrings.stats,
                  path: Routes.stats,
                ),
                listTile(
                  iconData: Icons.category,
                  label: PStrings.priceList,
                  path: Routes.priceList,
                ),
                listTile(
                  iconData: Icons.show_chart,
                  label: PStrings.charts,
                  path: Routes.charts,
                ),
                PDivider(indent: 28, height: Settings.pagePadding),
                listSection("Other"),
                listTile(
                  iconData: Icons.settings,
                  label: PStrings.settings,
                  path: Routes.settings,
                ),
                listTile(
                  iconData: Icons.logout,
                  label: PStrings.logout,
                  path: Routes.login,
                ),
                SizedBox(height: Settings.pagePadding * 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
