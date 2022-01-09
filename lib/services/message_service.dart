import 'package:appchat/model/chat_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  static const String _collection = 'messages';
  static final _firestore = FirebaseFirestore.instance;

  static void sendMessage({
    required String content,
    required int type,
    required String groupChatId,
    required String currentUserId,
    required String peerId,
  }) {
    DocumentReference documentReference = _firestore
        .collection(_collection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
      favorite: '',
    );

    _firestore.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  static Future updateMessage({
    required String groupChatId,
    required String path,
    required Map<String, String> dataUpdate,
  }) {
    return _firestore
        .collection(_collection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(path)
        .update(dataUpdate);
  }

  static Future<void> updateDataFirestore(
      String docPath, Map<String, dynamic> dataNeedUpdate) {
    return _firestore
        .collection(_collection)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  static Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return _firestore
        .collection(_collection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
