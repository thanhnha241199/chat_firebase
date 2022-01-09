import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../constants.dart';

class FullPhotoPage extends StatelessWidget {
  static const id = 'full_image_screen';
  final String url;
  const FullPhotoPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(url),
            loadingBuilder: (context, event) => const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: kPrimaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
