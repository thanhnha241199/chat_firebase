import 'dart:io';

import 'package:appchat/screens/widgets/widgets.dart';
import 'package:appchat/services/services.dart';
import 'package:appchat/static_varibale.dart';
import 'package:appchat/util/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  final String uid;
  final String name;
  final String avatar;
  const ChatScreen({
    Key? key,
    required this.uid,
    required this.name,
    required this.avatar,
  }) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();

  bool _isComposing = false;
  String groupChatId = "";
  final int _limit = 20;
  final key = GlobalKey();
  List<QueryDocumentSnapshot> listMessage = [];

  Future _sendMessage() async {
    final message = _messageController.text.trim();
    setState(() {
      _messageController.clear();
      _isComposing = false;
    });
    MessageService.sendMessage(
      content: message,
      currentUserId: StaticVariable.uid ?? '',
      groupChatId: groupChatId,
      peerId: widget.uid,
      type: 1,
    );
  }

  Future _sendImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final url = await UserService.uploadFireStorage(image.path);
      MessageService.sendMessage(
        content: url,
        currentUserId: StaticVariable.uid ?? '',
        groupChatId: groupChatId,
        peerId: widget.uid,
        type: 0,
      );
    }
  }

  Future _sendFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      await UserService.uploadPdfToStorage(File(result.files.single.path!));
      MessageService.sendMessage(
        content: result.files.single.name,
        currentUserId: StaticVariable.uid ?? '',
        groupChatId: groupChatId,
        peerId: widget.uid,
        type: 2,
      );
    }
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: IconButton(
              onPressed: _sendImage,
              icon: const Icon(Icons.image),
              color: kPrimaryColor,
            ),
          ),
          Flexible(
            child: IconButton(
              onPressed: _sendFile,
              icon: const Icon(Icons.attach_file),
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 8,
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              decoration: InputDecoration.collapsed(
                hintText: 'Your message here...',
                hintStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: kContentColorLightTheme),
              ),
              onChanged: (value) {
                setState(() {
                  _isComposing = value.isNotEmpty;
                });
              },
            ),
          ),
          Flexible(
            child: IconButton(
              onPressed: _isComposing ? _sendMessage : null,
              icon: const Icon(Icons.send),
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() {
    if (StaticVariable.uid!.compareTo(widget.uid) > 0) {
      groupChatId = '${StaticVariable.uid}-${widget.uid}';
    } else {
      groupChatId = '${widget.uid}-${StaticVariable.uid}';
    }

    MessageService.updateDataFirestore(
      StaticVariable.uid ?? '',
      {'peerId': widget.uid},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ToastView.show("Coming soon!");
            },
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              ToastView.show("Coming soon!");
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: MessageService.getChatStream(groupChatId, _limit),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Text('Firestore snapshot has error..');
                }
                if (snapshot.data == null) {
                  return const Text("Snapshot.data is null..");
                } else {
                  final docs = snapshot.data.docs;
                  listMessage = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: docs.length,
                    reverse: true,
                    itemBuilder: (context, index) => ItemMessage(
                      index: index,
                      document: snapshot.data?.docs[index],
                      groupChatId: groupChatId,
                    ),
                  );
                }
              },
            ),
          ),
          const Divider(),
          _buildComposer(),
        ],
      ),
    );
  }
}
