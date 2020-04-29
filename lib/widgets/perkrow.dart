import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrunes/api/models.dart';

class PerksRow extends StatelessWidget {
  PerksRow(this.perks, {this.size = 32, this.rightPadding = 3});

  final PerksModel perks;
  final double size;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    final runes = perks.rows
        .map((e) => _PerkImage(
              perk: e,
              size: size,
              margin: EdgeInsets.all(2),
            ))
        .toList();

    return Container(
      padding: EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
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

class _PerkImage extends StatelessWidget {
  _PerkImage({this.perk, this.size = 32, this.margin});

  final String perk;
  final double size;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: perkColor(perk),
          image: DecorationImage(
            scale: 6,
            image: AssetImage('assets/rune-avis/perks/$perk.png'),
          )),
    );
  }
}

Color perkColor(String perk) {
  switch (perk) {
    case 'axe':
      return Color.fromRGBO(255, 193, 7, 0.3);
    case 'circle':
      return Color.fromRGBO(170, 71, 188, 0.3);
    case 'diamond':
      return Color.fromRGBO(63, 81, 181, 0.3);
    case 'heart':
      return Color.fromRGBO(76, 175, 79, 0.3);
    case 'shield':
      return Color.fromRGBO(244, 67, 54, 0.3);
    case 'time':
      return Color.fromRGBO(255, 235, 59, 0.3);
  }
}
