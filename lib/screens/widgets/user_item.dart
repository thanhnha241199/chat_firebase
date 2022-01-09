import 'package:appchat/constants.dart';
import 'package:appchat/screens/screens.dart';
import 'package:appchat/screens/widgets/widgets.dart';
import 'package:appchat/services/services.dart';
import 'package:appchat/util/dialog.dart';
import 'package:flutter/material.dart';

import '../../static_varibale.dart';

class UserItem extends StatefulWidget {
  const UserItem({Key? key}) : super(key: key);

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        CachedImage(
          imageUrl: StaticVariable.avatar ?? 'https://bit.ly/3ncyGiH',
          height: 50,
          width: 50,
          borderRadius: 100,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
              child: Text(
                'Chat',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
              child: Text(
                'Hello ${StaticVariable.email}!',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: kPrimaryColor),
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () => showConfirmDialog(
            context: context,
            confirmTap: () async {
              StaticVariable.uid = '';
              StaticVariable.email = '';
              await AuthService.signOut();
              final result = await Navigator.pushNamedAndRemoveUntil(
                  context, SignInScreen.id, (route) => false);
              if (result == 'true') {
                setState(() {});
              }
            },
          ),
          tooltip: 'Sign out',
        ),
      ],
    );
  }
}
