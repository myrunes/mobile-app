import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrunes/api/api.dart';
import 'package:myrunes/api/models.dart';
import 'package:myrunes/widgets/picker.dart';
import 'package:myrunes/widgets/roundimage.dart';

class PageEditorScreen extends StatefulWidget {
  PageEditorScreen(this.apiInstance);

  final API apiInstance;

  @override
  State<StatefulWidget> createState() =>
      _PageEditorScreenState(this.apiInstance);
}

class _AppBarTitle extends StatelessWidget {
  _AppBarTitle(this.apiInstance, this.page);

  final API apiInstance;
  final PageModel page;

  void _onSavePressed(BuildContext context) async {
    try {
      await apiInstance.updatePage(page);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Page updated.'),
        backgroundColor: Colors.green,
      ));
    } catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${page.title} (edit)'),
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save page',
            onPressed: () => _onSavePressed(context),
          )
        ]);
  }
}

class _PageEditorScreenState extends State<PageEditorScreen> {
  _PageEditorScreenState(this.apiInstance);

  final API apiInstance;
  PageModel _page;

  @override
  Widget build(BuildContext context) {
    _page = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(title: _AppBarTitle(apiInstance, _page)),
        body: _PageEditorScreenContent(
          _page,
          apiInstance,
          onChampionRemove: (c) => setState(() {
            _page.champions.remove(c);
          }),
          onChampionAdd: (c) => setState(() {
            _page.champions.add(c);
          }),
        ));
  }
}

class _PageEditorScreenContent extends StatelessWidget {
  _PageEditorScreenContent(this.page, this.apiInstance,
      {this.onChampionRemove, this.onChampionAdd});

  final API apiInstance;
  final PageModel page;
  final void Function(String champ) onChampionRemove;
  final void Function(String champ) onChampionAdd;

  @override
  Widget build(BuildContext context) {
    final champions = page.champions
        .map<Widget>((c) => PickerElement(
            avatar: AssetImage('assets/champ-avis/$c.png'),
            label: apiInstance.champions.data
                .firstWhere((champ) => champ.uid == c)
                .name,
            onDelete: () => onChampionRemove(c)))
        .toList();

    apiInstance.champions.data.sort((a, b) => a.name.compareTo(b.name));
    final championsSubset = apiInstance.champions.data
        .where((c) => !page.champions.contains(c.uid))
        .map<Widget>((c) => ListTile(
              leading: RoundImage(
                image: AssetImage('assets/champ-avis/${c.uid}.png'),
                width: 30,
                height: 30,
              ),
              title: Text(c.name),
              onTap: () {
                Navigator.pop(context);
                onChampionAdd(c.uid);
              },
            ))
        .toList();

    return Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Picker(
          subset: championsSubset,
          value: champions,
        ));
  }
}
