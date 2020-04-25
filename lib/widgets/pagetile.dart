import 'package:myrunes/api/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:myrunes/widgets/roundimage.dart';
import 'package:myrunes/widgets/treetow.dart';

class PageTile extends StatelessWidget {
  PageTile(this.page);

  final PageModel page;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageHeader(page),
          TreeRow(page.primary),
          TreeRow(page.secondary),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  _PageHeader(this.page);

  final PageModel page;

  @override
  Widget build(BuildContext context) {
    final rowElements = <Widget>[
      Container(
        margin: EdgeInsets.only(right: 10),
        child: Text(
          page.title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ];

    rowElements.addAll(page.champions.map((e) => RoundImage(
          image: AssetImage('assets/champ-avis/$e.png'),
          width: 16,
          height: 16,
          margin: EdgeInsets.only(right: 2),
        )));

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(children: rowElements),
    );
  }
}
