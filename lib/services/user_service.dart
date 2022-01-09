import 'dart:io';
import 'package:appchat/util/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserService {
  static const String _collection = 'user';
  static final _firestore = FirebaseFirestore.instance;
  static final _firebaseStorage = FirebaseStorage.instance;

  static Future addUser({
    required String email,
    required String name,
    required String uid,
  }) async {
    await _firestore.collection(_collection).doc(uid).set({
      'email': email,
      'name': name,
      'uid': uid,
      'avatar': '',
      'description': '',
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'updatedAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  static Future<String?> uploadPdfToStorage(File pdfFile) async {
    try {
      EasyLoading.show();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('pdfs/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask =
          ref.putFile(pdfFile, SettableMetadata(contentType: 'pdf'));
      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();
      EasyLoading.dismiss();
      return url;
    } catch (e) {
      EasyLoading.dismiss();
      ToastView.show(e.toString());
    }
  }

  static Future<String> uploadFireStorage(String filePath,
      {String? path, bool isResize = true, int resizeWidth = 1080}) async {
    if (filePath.isEmpty) return '';
    File file = File(filePath);
    if ((await file.length()) > 20 * 1024 * 1024) {
      ToastView.show(
          'File có kích thước quá lớn, vui lòng upload file có dung lương < 20MB');
      return '';
    }
    try {
      Reference storageReference = _firebaseStorage.ref().child(
          '${path ?? 'root'}/${DateTime.now().toString().replaceAll(' ', '')}');
      UploadTask uploadTask = storageReference.putFile(file);
      EasyLoading.show();
      await uploadTask.whenComplete(() {});
      EasyLoading.dismiss();
      final fileURL = await storageReference.getDownloadURL();
      return fileURL;
    } catch (e) {
      throw Exception("Upload file thất bại. Xin vui lòng thử lại");
    }
  }

  static Future updateUser({
    required String path,
    required Map<String, String> dataUpdate,
  }) {
    return _firestore.collection(_collection).doc(path).update(dataUpdate);
  }

  static Stream<DocumentSnapshot> getProfile({required String uid}) {
    return _firestore.collection(_collection).doc(uid).snapshots();
  }

  static Stream<QuerySnapshot> userStream() {
    return _firestore.collection(_collection).snapshots();
  }
}
