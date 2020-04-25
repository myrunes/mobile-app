import 'package:flutter/cupertino.dart';
import 'package:myrunes/api/models.dart';
import 'package:myrunes/widgets/runeimage.dart';

class TreeRow extends StatelessWidget {
  TreeRow(this.tree, {this.size = 32, this.rightPadding = 3});

  final TreeModel tree;
  final double size;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    final runes = <Widget>[
      RuneImage(
          path: 'assets/rune-avis/${tree.tree}.png',
          size: size,
          padding: EdgeInsets.only(right: rightPadding))
    ];

    runes.addAll(tree.rows
        .map((e) => RuneImage(
              path: 'assets/rune-avis/${tree.tree}/$e.png',
              size: size,
              padding: EdgeInsets.only(right: rightPadding),
            ))
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
      return Color.fromRGBO(255, 255, 255, 0.25);
  }
}
