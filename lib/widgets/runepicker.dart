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

  int _getSecRow(String runeUID) {
    final runes = apiInstance.runes.trees
        .firstWhere((t) => t.uid == secondary.tree)
        .slots
        .sublist(1)
        .toList();

    var i = 0;
    for (final slot in runes) {
      if (slot.runes.where((r) => r.uid == runeUID).length > 0) {
        return i;
      }
      i++;
    }

    return -1;
  }

  void _onPrimarySelect(int i, Rune r) {
    primary.rows[i] = r.uid;
    onUpdate();
  }

  void _onSecondarySelect(int i, Rune r) {
    if (secondary.rows.length < 2) {
      secondary.rows = [null, null];
    }

    if (_getSecRow(r.uid) == _getSecRow(secondary.rows[0])) {
      secondary.rows[0] = r.uid;
      return onUpdate();
    }

    if (secondary.rows[0] != null && secondary.rows[1] != null) {
      secondary.rows[1] = secondary.rows[0];
      secondary.rows[0] = r.uid;
    } else if (secondary.rows[0] != null) {
      secondary.rows[1] = r.uid;
    } else {
      secondary.rows[0] = r.uid;
    }

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

    final List<Widget> primaryElements = [];
    final List<Widget> secondaryElements = [];

    // Primary Header
    primaryElements.add(Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: const Text(
        'Primary Tree',
        style: TextStyle(fontSize: 16),
      ),
    ));

    // Primary Runes
    if (primary.tree != null) {
      for (var i = 0; i < 4; i++) {
        primaryElements.add(_PrimaryRuneRow(
            tree: primary,
            onSelect: (r) => _onPrimarySelect(i, r),
            runes: apiInstance.runes.trees
                .firstWhere((t) => t.uid == primary.tree)
                ?.slots[i]
                ?.runes));
      }
    }

    // Secondary Header
    secondaryElements.add(Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: const Text(
        'Secondary Tree',
        style: TextStyle(fontSize: 16),
      ),
    ));

    // Secondary Runes
    if (secondary.tree != null) {
      for (var i = 1; i < 4; i++) {
        secondaryElements.add(_PrimaryRuneRow(
            tree: secondary,
            onSelect: (r) => _onSecondarySelect(i, r),
            runes: apiInstance.runes.trees
                .firstWhere((t) => t.uid == secondary.tree)
                ?.slots[i]
                ?.runes));
      }
    }

    return SingleChildScrollView(
      child: Column(children: [
        // Tree Picker
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: treePickerElements,
          ),
        ),
        // Primary Tree Picker
        Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(255, 255, 255, 0.1)),
          child: (primary.tree != null)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: primaryElements,
                  ),
                )
              : null,
        ),
        // Secondary Tree Picker
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(255, 255, 255, 0.1)),
          child: (secondary.tree != null)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: secondaryElements,
                  ),
                )
              : null,
        )
      ]),
    );
  }
}

class _PrimaryRuneRow extends StatelessWidget {
  _PrimaryRuneRow(
      {@required this.tree, @required this.runes, @required this.onSelect});

  final TreeModel tree;
  final List<Rune> runes;
  final void Function(Rune) onSelect;

  @override
  Widget build(BuildContext context) {
    final elements = runes
        .map((r) => _Selector(
              image: AssetImage('assets/rune-avis/${tree.tree}/${r.uid}.png'),
              enabled: tree.rows.contains(r.uid),
              onTap: () => onSelect(r),
              padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
            ))
        .toList();

    return Row(children: elements);
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
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Container(
            width: size,
            height: size,
            margin: padding,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: image),
                border: Border.all(
                    color: enabled ? Colors.cyan : Colors.transparent,
                    width: 2)),
          ),
        ));
  }
}
