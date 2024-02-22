import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonAvatar extends StatelessWidget {
  final String image;
  const PersonAvatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: CachedNetworkImageProvider(image, cacheKey: image, errorListener: (p0) => {}),
    );
  }
}
