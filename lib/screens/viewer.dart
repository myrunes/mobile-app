import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrunes/api/api.dart';
import 'package:myrunes/api/models.dart';
import 'package:myrunes/widgets/perkrow.dart';
import 'package:myrunes/widgets/roundimage.dart';
import 'package:myrunes/widgets/treetow.dart';

class PageViewerScreen extends StatefulWidget {
  PageViewerScreen(this.apiInstance);

  final API apiInstance;

  @override
  State<StatefulWidget> createState() =>
      _PageViewerScreenState(this.apiInstance);
}

class _PageViewerScreenState extends State<PageViewerScreen> {
  _PageViewerScreenState(this.apiInstance);

  final API apiInstance;
  ViewerEditorArguments _args;

  @override
  Widget build(BuildContext context) {
    if (_args == null) {
      _args = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
        appBar: AppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text(_args.page.title),
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Edit page',
                onPressed: () async {
                  await Navigator.pushNamed(context, '/pages/edit',
                      arguments: _args);
                  this.setState(() {});
                },
              )
            ])),
        body: _PageViewerScreenContent(_args.page));
  }
}

class _PageViewerScreenContent extends StatelessWidget {
  _PageViewerScreenContent(this.page);

  final PageModel page;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final champs = page.champions
        .map((c) => RoundImage(
            image: AssetImage('assets/champ-avis/$c.png'),
            width: 32,
            height: 32,
            margin: EdgeInsets.only(left: 5)))
        .toList();

    return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: champs),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TreeRow(page.primary, size: screenWidth / 5.5),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TreeRow(page.secondary, size: screenWidth / 5.5),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PerksRow(page.perks, size: screenWidth / 7),
            )
          ],
        ));
  }
}
