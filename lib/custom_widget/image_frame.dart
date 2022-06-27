import 'package:flutter/material.dart';

class ImageFrame extends StatelessWidget {
  final IconButton emotion1;
  final IconButton emotion2;
  final IconButton emotion3;
  final IconButton emotion4;

  const ImageFrame(this.emotion1, this.emotion2, this.emotion3, this.emotion4,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emotion1,
            emotion2,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emotion3,
            emotion4,
          ],
        )
      ],
    );
  }
}
