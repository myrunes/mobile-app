import 'package:flutter/widgets.dart';

class RuneImage extends StatelessWidget {
  RuneImage({this.path, this.size = 32, this.padding});

  final String path;
  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Image(
        width: size,
        height: size,
        image: AssetImage(path),
      ),
    );
  }
}
