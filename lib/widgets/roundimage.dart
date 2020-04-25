import 'package:flutter/cupertino.dart';

class RoundImage extends StatelessWidget {
  RoundImage({@required this.image, this.width, this.height, this.margin});

  final ImageProvider image;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: image,
          )),
    );
  }
}
