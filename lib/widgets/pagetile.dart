import 'package:app/api/models.dart';
import 'package:flutter/cupertino.dart';

class PageTile extends StatelessWidget {
  PageTile(this.page);

  final PageModel page;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(page.title),
    );
  }

}