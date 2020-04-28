import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrunes/widgets/roundimage.dart';

class PickerElement extends StatelessWidget {
  PickerElement({@required this.label, this.avatar, this.onDelete});

  final ImageProvider avatar;
  final String label;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        padding: EdgeInsets.all(3),
        avatar: RoundImage(
          image: avatar,
          margin: EdgeInsets.all(0),
        ),
        label: Text(label),
        deleteIcon: Icon(Icons.close),
        onDeleted: onDelete,
      ),
    );
  }
}

class Picker extends StatelessWidget {
  Picker({@required this.value, @required this.subset, this.onChange});

  final List<Widget> value, subset;
  final void Function() onChange;

  Future<void> _openChampSelectDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Pick champion'),
            children: subset,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    widgets.addAll(value);
    widgets.add(Ink(
      decoration: const ShapeDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.1),
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () async {
          await _openChampSelectDialog(context);
        },
      ),
    ));

    return Wrap(children: widgets);
  }
}
