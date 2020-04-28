import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrunes/api/api.dart';
import 'package:myrunes/api/models.dart';
import 'package:myrunes/widgets/picker.dart';
import 'package:myrunes/widgets/roundimage.dart';
import 'package:myrunes/widgets/runepicker.dart';

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
  ViewerEditorArguments _args;
  PageModel _page;

  void onSaved() {
    _args.page = _page;
  }

  @override
  Widget build(BuildContext context) {
    if (_args == null) {
      _args = ModalRoute.of(context).settings.arguments;
      if (_args.isNew) {
        _page = PageModel();
        _args.page = _page;
      } else {
        final original = _args.page?.toMap();
        _page = PageModel.fromJson(original);
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: _AppBarTitle(apiInstance, _page, _args, onSaved: onSaved)),
      body: _PageEditorScreenContent(
        _page,
        apiInstance,
        onUpdate: setState,
      ),
    );
  }
}

class _PageEditorScreenContent extends StatelessWidget {
  _PageEditorScreenContent(this.page, this.apiInstance, {this.onUpdate});

  final API apiInstance;
  final PageModel page;
  final void Function(void Function()) onUpdate;

  @override
  Widget build(BuildContext context) {
    final champions = page.champions
        .map<Widget>((c) => PickerElement(
            avatar: AssetImage('assets/champ-avis/$c.png'),
            label: apiInstance.champions.data
                .firstWhere((champ) => champ.uid == c)
                .name,
            onDelete: () => onUpdate(() => page.champions.remove(c))))
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
                onUpdate(() => page.champions.add(c.uid));
              },
            ))
        .toList();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Page title',
                      ),
                      initialValue: page.title,
                      onChanged: (v) => onUpdate(() => page.title = v),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Picker(
                      subset: championsSubset,
                      value: champions,
                    ),
                  ),
                  RunePicker(
                    apiInstance,
                    page.primary,
                    page.secondary,
                    page.perks,
                    onUpdate: () => onUpdate(() {}),
                  )
                ],
              )));
    });
  }
}

class _AppBarTitle extends StatelessWidget {
  _AppBarTitle(this.apiInstance, this.page, this.args, {this.onSaved});

  final PageModel page;
  final API apiInstance;
  final ViewerEditorArguments args;
  final void Function() onSaved;

  void _onSavePressed(BuildContext context) async {
    try {
      if (args.isNew) {
        // TODO: Remove this when Perks are settable
        args.page.perks.rows = ['diamond', 'diamond', 'heart'];
        args.page = await apiInstance.createPage(page);
        args.pageList.add(args.page);
        onSaved();
        Navigator.pop(context, true);
      } else {
        await apiInstance.updatePage(page);
        onSaved();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Page updated.'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (err) {
      final errStr = err is APIError
          ? '${err.reason} (${err.statusCode})'
          : err.toString();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(errStr),
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
          Text('${page?.title ?? 'new page'} (edit)'),
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save page',
            onPressed: () => _onSavePressed(context),
          )
        ]);
  }
}
