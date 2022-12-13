import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key? key,
    required this.userId,
    this.timestamp,
  }) : super(key: key);

  final int userId;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    final GlobalController global = Get.find();

    User user = global.homeData != null ?
        findUser(id: userId, userList: global.homeData!.users) :
        findUser(id: userId, userList: global.users!);

    if (timestamp != null) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: Settings.fullRadius,
            child: _image(user.profileUrl),
          ),
          SizedBox(width: Settings.pagePadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: PStyles().onSurface(context).bodyMedium),
              Text(
                formatDate(timestamp!, short: true),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        ClipRRect(
          borderRadius: Settings.fullRadius,
          child: _image(user.profileUrl),
        ),
        SizedBox(width: Settings.pagePadding),
        Text(user.name, style: PStyles().onSurface(context).bodyLarge),
      ],
    );
  }

  Widget _image(String? profileUrl) {
    if (profileUrl is String) {
      return SizedBox(
        height: 40,
        width: 40,
        child: Image.network(
          profileUrl,
          cacheHeight: 110,
          cacheWidth: 110,
          errorBuilder: (
            BuildContext context,
            Object exception,
            StackTrace? stackTrace,
          ) => _missing(),
        ),
      );
    }

    return _missing();
  }

  Widget _missing() {
    return const Icon(Icons.account_circle, size: 40);
  }
}
