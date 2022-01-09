import 'dart:io';

import 'package:appchat/screens/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUser extends StatelessWidget {
  final String? avatar;
  final XFile? image;
  final VoidCallback? onTap;
  const AvatarUser({
    Key? key,
    required this.avatar,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return avatar == ''
        ? Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: onTap,
                  child: const Icon(Icons.camera),
                ),
              ),
            ],
          )
        : (avatar != '' && image == null)
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: CachedImage(
                      height: 100,
                      width: 100,
                      borderRadius: 100,
                      imageUrl: avatar ?? '',
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: onTap,
                      child: const Icon(Icons.camera),
                    ),
                  ),
                ],
              )
            : image != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: onTap,
                          child: const Icon(Icons.camera),
                        ),
                      ),
                    ],
                  )
                : Container();
  }
}
