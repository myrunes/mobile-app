import 'package:app/api/api.dart';
import 'package:app/api/models.dart';
import 'package:app/widgets/pagetile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.apiInstance}) : super(key: key);

  final String title;
  final API apiInstance;

  @override
  _HomePageState createState() => _HomePageState(apiInstance);
}

class _HomePageContent extends StatelessWidget {
  _HomePageContent(this.pages);

  final List<PageModel> pages;

  @override
  Widget build(BuildContext context) {
    final pageWidgets = pages.map((e) => PageTile(e)).toList();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pageWidgets,
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.apiInstance);

  final API apiInstance;
  List<PageModel> pages = List();

  @override
  void initState() {
    apiInstance.getMe()
      .then((_) {
        _fetchData();
      })
      .catchError((err) {
        if (err is APIError && err.statusCode == 401)
          Navigator.pushNamed(context, '/login');
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: _HomePageContent(pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _fetchData() async {
    var pList = await apiInstance.getPages();
    setState(() {
      pages = pList.data;
    });
  }
}