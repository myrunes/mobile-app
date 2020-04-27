import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrunes/api/api.dart';
import 'package:myrunes/api/models.dart';

class RunePicker extends StatelessWidget {
  RunePicker(this.apiInstance, this.primary, this.secondary, this.perks,
      {this.onUpdate});

  final API apiInstance;
  final TreeModel primary, secondary;
  final PerksModel perks;
  final void Function() onUpdate;

  void _onTreeSelect(String t) {
    if (secondary.tree != null) {
      if (t == secondary.tree) {
        secondary.tree = null;
        secondary.rows = [];
      } else if (t != primary.tree) {
        secondary.tree = t;
        secondary.rows = [];
      }
      return onUpdate();
    }

    if (t == primary.tree) {
      primary.tree = null;
      primary.rows = [];
      return onUpdate();
    }

    if (primary.tree != null) {
      secondary.tree = t;
      secondary.rows = [];
      return onUpdate();
    }

    primary.tree = t;
    primary.rows = [];

    onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final treePickerElements = apiInstance.runes.trees
        .map((t) => _Selector(
            image: AssetImage('assets/rune-avis/${t.uid}.png'),
            enabled: primary.tree == t.uid || secondary.tree == t.uid,
            padding: EdgeInsets.only(right: 8),
            onTap: () => _onTreeSelect(t.uid)))
        .toList();

    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: treePickerElements,
      )
    ]);
  }
}

class _Selector extends StatelessWidget {
  _Selector(
      {@required this.image,
      @required this.onTap,
      this.enabled = false,
      this.size = 40,
      this.padding});

  final ImageProvider image;
  final bool enabled;
  final double size;
  final EdgeInsets padding;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          margin: padding,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: image),
              border: Border.all(
                  color: enabled ? Colors.cyan : Colors.transparent, width: 2)),
        ));
  }
}
