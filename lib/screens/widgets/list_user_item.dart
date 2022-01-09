import 'package:appchat/screens/chat_screen.dart';
import 'package:appchat/screens/widgets/cached_image.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class ListUserItem extends StatelessWidget {
  final String name;
  final String avatar;
  final String uid;
  final String description;
  const ListUserItem({
    Key? key,
    required this.name,
    required this.avatar,
    required this.uid,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatScreen.id,
          arguments: {
            "uid": uid,
            "name": name,
            "avatar": avatar,
          },
        );
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Stack(
                children: [
                  if (avatar != '')
                    CachedImage(
                      imageUrl: avatar,
                      height: 60,
                      width: 60,
                      borderRadius: 100,
                    ),
                  if (avatar == '')
                    const CachedImage(
                      height: 60,
                      width: 60,
                      borderRadius: 100,
                    ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: kContentColorLightTheme,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description == '' ? 'No description' : description,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: kContentColorLightTheme),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "1m ago",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: kPrimaryColor),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
