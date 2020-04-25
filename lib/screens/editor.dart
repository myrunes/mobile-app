import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrunes/api/api.dart';
import 'package:myrunes/api/models.dart';
import 'package:myrunes/widgets/picker.dart';

class PageEditorScreen extends StatefulWidget {
  PageEditorScreen(this.apiInstance);

  final API apiInstance;

  @override
  State<StatefulWidget> createState() =>
      _PageEditorScreenState(this.apiInstance);
}

class _PageEditorScreenState extends State<PageEditorScreen> {
  _PageEditorScreenState(this.apiInstance);

  final API apiInstance;
  PageModel _page;

  @override
  Widget build(BuildContext context) {
    _page = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text('${_page.title} (edit)'),
              IconButton(
                icon: Icon(Icons.save),
                tooltip: 'Save page',
                onPressed: () {},
              )
            ])),
        body: _PageEditorScreenContent(
          _page,
          onChampionRemove: (c) => setState(() {
            _page.champions.remove(c);
          }),
        ));
  }
}

class _PageEditorScreenContent extends StatelessWidget {
  _PageEditorScreenContent(this.page, {this.onChampionRemove});

  final PageModel page;
  final void Function(String champ) onChampionRemove;

  @override
  Widget build(BuildContext context) {
    final champions = page.champions
        .map<Widget>((c) => PickerElement(
            avatar: AssetImage('assets/champ-avis/$c.png'),
            label: c,
            onDelete: () => onChampionRemove(c)))
        .toList();

    return Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Picker(
          subset: [],
          value: champions,
        ));
  }
}

class AsssetsImage {}

class AsssetImage {}
