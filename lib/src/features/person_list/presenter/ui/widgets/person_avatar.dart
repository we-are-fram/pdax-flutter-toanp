import 'package:flutter/material.dart';

class PersonAvatar extends StatelessWidget {
  final String image;
  const PersonAvatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(image),
      radius: 50,
    );
  }
}
