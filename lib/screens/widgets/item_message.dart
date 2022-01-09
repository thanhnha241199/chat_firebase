import 'package:appchat/constants.dart';
import 'package:appchat/model/chat_model.dart';
import 'package:appchat/screens/widgets/cached_image.dart';
import 'package:appchat/screens/widgets/full_image.dart';
import 'package:appchat/screens/widgets/over_play.dart';
import 'package:appchat/services/message_service.dart';
import 'package:appchat/static_varibale.dart';
import 'package:appchat/util/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemMessage extends StatefulWidget {
  final int index;
  final String groupChatId;
  final DocumentSnapshot? document;
  const ItemMessage({
    Key? key,
    required this.index,
    this.document,
    required this.groupChatId,
  }) : super(key: key);

  @override
  State<ItemMessage> createState() => _ItemMessageState();
}

class _ItemMessageState extends State<ItemMessage> {
  final key = GlobalKey();
  Future _updateMessage(String path, bool status) async {
    MessageService.updateMessage(
      groupChatId: widget.groupChatId,
      path: path,
      dataUpdate: {
        "favorite": '$status',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.document != null) {
      MessageChat messageChat = MessageChat.fromDocument(widget.document!);

      return GestureDetector(
        key: key,
        onLongPress: () {
          RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              transitionDuration: const Duration(seconds: 300),
              pageBuilder: (context, animation1, animation2) {
                return OverPopupPage(
                  offset: position,
                  isLeft:
                      messageChat.idFrom == StaticVariable.uid ? false : true,
                  like: () {
                    _updateMessage(messageChat.timestamp, true);
                  },
                  dislike: () {
                    _updateMessage(messageChat.timestamp, false);
                  },
                );
              },
            ),
          );
        },
        child: Row(
          mainAxisAlignment: messageChat.idFrom == StaticVariable.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (messageChat.favorite == 'true' &&
                messageChat.idFrom == StaticVariable.uid)
              const Center(
                child: CircleAvatar(
                  radius: 10,
                  child: Icon(
                    Icons.favorite_sharp,
                    size: 15,
                  ),
                ),
              ),
            messageChat.type == 1
                ? Container(
                    margin: EdgeInsets.only(
                      bottom:
                          messageChat.idFrom == StaticVariable.uid ? 20 : 10,
                      right: 10,
                    ),
                    child: Text(
                      messageChat.content,
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: kContentColorLightTheme),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                        color: messageChat.idFrom == StaticVariable.uid
                            ? kPrimaryColor
                            : Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30)),
                  )
                : messageChat.type == 0
                    ? Container(
                        margin: EdgeInsets.only(
                            bottom: messageChat.idFrom == StaticVariable.uid
                                ? 20
                                : 10,
                            right: 10),
                        child: OutlinedButton(
                          child: Material(
                            child: CachedImage(
                              imageUrl: messageChat.content,
                              width: 200,
                              height: 200,
                              borderRadius: 8,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              FullPhotoPage.id,
                              arguments: {
                                "url": messageChat.content,
                              },
                            );
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(0))),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          ToastView.show("Coming soon!");
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: messageChat.idFrom == StaticVariable.uid
                                ? 20
                                : 10,
                            right: 10,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              color: messageChat.idFrom == StaticVariable.uid
                                  ? kPrimaryColor
                                  : Colors.grey.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file),
                              Text(
                                messageChat.content,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
            if (messageChat.favorite == 'true' &&
                messageChat.idFrom != StaticVariable.uid)
              const Center(
                child: CircleAvatar(
                  radius: 10,
                  child: Icon(
                    Icons.favorite_sharp,
                    size: 15,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
