import 'package:myrunes/api/models.dart';
import 'package:flutter/cupertino.dart';

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
          _TreeRow(page.primary),
          _TreeRow(page.secondary),
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

    rowElements.addAll(page.champions.map((e) => Container(
          width: 16,
          height: 16,
          margin: EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/champ-avis/$e.png'),
              )),
        )));

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(children: rowElements),
    );
  }
}

class _TreeRow extends StatelessWidget {
  _TreeRow(this.tree);

  final TreeModel tree;

  @override
  Widget build(BuildContext context) {
    final runes = <Widget>[
      _RuneImage(path: 'assets/rune-avis/${tree.tree}.png'),
    ];

    runes.addAll(tree.rows
        .map((e) => _RuneImage(path: 'assets/rune-avis/${tree.tree}/$e.png'))
        .toList());

    return Container(
      padding: EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 5),
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

class _RuneImage extends StatelessWidget {
  _RuneImage(
      {this.path, this.height = 32, this.width = 32, this.rightPadding = 3});

  final String path;
  final double height;
  final double width;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: Image(
        width: width,
        height: height,
        image: AssetImage(path),
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
    case 'resolve':
      return Color.fromRGBO(104, 159, 56, 0.25);
    default:
      return null;
  }
}
