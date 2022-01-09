import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  String favorite;
  int type;

  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.favorite,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'favorite': favorite,
      'content': content,
      'type': type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get('idFrom');
    String idTo = doc.get('idTo');
    String timestamp = doc.get('timestamp');
    String content = doc.get('content');
    int type = doc.get('type');
    String favorite = doc.get('favorite');
    return MessageChat(
      idFrom: idFrom,
      idTo: idTo,
      timestamp: timestamp,
      content: content,
      favorite: favorite,
      type: type,
    );
  }
}
