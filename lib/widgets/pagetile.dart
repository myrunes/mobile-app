import 'package:app/api/models.dart';
import 'package:flutter/cupertino.dart';

class PageTile extends StatelessWidget {
  PageTile(this.page);

  final PageModel page;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(page.title),
          _TreeRow(page.primary),
          _TreeRow(page.secondary),
        ],
      ),
    );
  }
}

class _TreeRow extends StatelessWidget {
  _TreeRow(this.tree);

  final TreeModel tree;

  @override
  Widget build(BuildContext context) {
    final runes = <Widget>[
      Image(
        width: 32,
        image: AssetImage('assets/rune-avis/${tree.tree}.png'),
      ),
    ];

    runes.addAll(tree.rows
        .map((e) => Image(
              width: 32,
              image: AssetImage('assets/rune-avis/${tree.tree}/$e.png'),
            ))
        .toList());

    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: _treeColor(tree.tree),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FittedBox(
        child: Row(
          children: runes,
        ),
      ),
    );
  }
}

Color _treeColor(String tree) {
  switch (tree) {
    case 'domination':
      return Color.fromRGBO(211, 47, 47, 0.25);
    case 'inspiration':
      return Color.fromRGBO(0, 150, 167, 0.25);
    case 'precision':
      return Color.fromRGBO(251, 193, 45, 0.25);
    case 'sorcery':
      return Color.fromRGBO(2, 137, 209, 0.25);
  }
}
