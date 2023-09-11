import 'dart:io';

import 'package:flutter/material.dart';

import '../my_default_settings.dart';

class UserProfilePhoto extends StatelessWidget {
  final double size;
  final String? url;
  final String? token;
  final bool isLocalPhoto;
  const UserProfilePhoto({
    super.key,
    required this.size,
    this.url,
    this.token,
    this.isLocalPhoto = false,
  });

  @override
  Widget build(BuildContext context) {
    return body(
      context: context,
      url: url,
      isLocalPhoto: isLocalPhoto,
      token: token,
    );
  }

  Widget body({
    required BuildContext context,
    String? url,
    String? token,
    required bool isLocalPhoto,
  }) {
    return Container(
      padding: EdgeInsets.all(MyDefaultSettings.gutter / 4),
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Colors.grey[300],
      ),
      child: image(
        context: context,
        url: url,
        isLocalPhoto: isLocalPhoto,
        token: token,
      ),
    );
  }

  Widget image({
    required BuildContext context,
    String? url,
    String? token,
    required bool isLocalPhoto,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: url != null && url.isNotEmpty
          ? isLocalPhoto
              ? Image.network(
                  url,
                  headers: token!.isNotEmpty
                      ? {'Authorization': 'Bearer $token'}
                      : null,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => LayoutBuilder(
                    builder: (context, constraints) => errorImage(
                      size: constraints.biggest.height,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                )
              : Image.file(
                  File(url),
                  fit: BoxFit.cover,
                )
          : (() => LayoutBuilder(
                builder: (context, constraints) => errorImage(
                  size: constraints.biggest.height,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ))(),
    );
  }

  errorImage({required double size, required Color color}) {
    return Icon(
      Icons.person,
      size: size,
      color: color,
    );
  }
}
