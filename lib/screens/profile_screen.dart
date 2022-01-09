import 'package:appchat/screens/widgets/widgets.dart';
import 'package:appchat/services/services.dart';
import 'package:appchat/util/keyboard.dart';
import 'package:appchat/util/show_toast.dart';
import 'package:appchat/static_varibale.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _avatarController = TextEditingController();
  XFile? _image;
  final _emailFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  String? _emailErrorText;
  String? _displayNameErrorText;
  String? _descriptionErrorText;
  bool isSuccess = false;

  Map<String, dynamic> _validateForm() {
    // Reset validation state
    setState(() {
      _emailErrorText = null;
      _displayNameErrorText = null;
      _descriptionErrorText = null;
    });

    bool isValid = true;

    final email = _emailController.text.trim();
    final displayName = _displayNameController.text.trim();
    final description = _descriptionController.text.trim();

    setState(() {
      if (displayName.isEmpty) {
        _displayNameErrorText = 'Please enter display name';
        isValid = false;
      }
      if (description.isEmpty) {
        _descriptionErrorText = 'Please enter description';
        isValid = false;
      }
    });

    return {
      'isValid': isValid,
      'email': email,
      'displayName': displayName,
      'description': description,
    };
  }

  Future _updateUser() async {
    final formData = _validateForm();
    if (formData['isValid']) {
      String? urlAvatar;
      if (_image != null) {
        urlAvatar = await UserService.uploadFireStorage(_image?.path ?? '');
        StaticVariable.avatar = urlAvatar;
      }
      EasyLoading.show();
      final user = await AuthService.currentUser();
      await UserService.updateUser(
        path: user?.uid ?? '',
        dataUpdate: {
          "name": _displayNameController.text,
          "avatar": urlAvatar ?? _avatarController.text,
          'description': _descriptionController.text,
        },
      );
      KeyBoardUtil.closeKeyboard(context);
      EasyLoading.dismiss();
      ToastView.show("Update success");
      setState(() {
        isSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: UserService.getProfile(uid: StaticVariable.uid ?? ''),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Text('Firestore snapshot is loading..');
          }
          if (snapshot.hasError) {
            return const Text('Firestore snapshot has error..');
          }
          if (snapshot.data == null) {
            return const Text("Snapshot.data is null..");
          } else {
            final docs = snapshot.data;
            _displayNameController.text = docs['name'];
            _emailController.text = docs['email'];
            _avatarController.text = docs['avatar'];
            _descriptionController.text = docs['description'];
            final avatar = docs['avatar'];
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AvatarUser(
                          avatar: avatar,
                          image: _image,
                          onTap: () async {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {
                              _image = image;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _emailErrorText,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          readOnly: true,
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _displayNameController,
                          focusNode: _displayNameFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Display name',
                            errorText: _displayNameErrorText,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            _displayNameFocusNode.unfocus();
                            _descriptionFocusNode.requestFocus();
                          },
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            errorText: _descriptionErrorText,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            _descriptionFocusNode.unfocus();
                          },
                        ),
                        const SizedBox(height: 12.0),
                        MaterialButton(
                          onPressed: _updateUser,
                          child: const Text('Update info'),
                          color: kPrimaryColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context, isSuccess.toString());
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
