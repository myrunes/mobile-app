import 'package:myrunes/api/api.dart';
import 'package:myrunes/api/models.dart';
import 'package:myrunes/widgets/pagetile.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.apiInstance}) : super(key: key);

  final String title;
  final API apiInstance;

  @override
  _HomePageState createState() => _HomePageState(apiInstance);
}

class _HomePageContent extends StatelessWidget {
  _HomePageContent({this.pages, this.onRefresh});

  final List<PageModel> pages;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final pageWidgets = <Widget>[
      Container(
        height: 10,
      )
    ];
    pageWidgets.addAll(pages.map((e) => PageTile(e)).toList());

    return Container(
      child: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 400,
        showChildOpacityTransition: false,
        onRefresh: onRefresh,
        child: ListView(
          children: pageWidgets,
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.apiInstance);

  final API apiInstance;
  List<PageModel> _pages = List();
  PackageInfo _packInfo;

  @override
  void initState() {
    apiInstance.getMe().then((_) {
      _fetchData();
    }, onError: (err) {
      if (err is APIError && err.statusCode == 401)
        Navigator.pushReplacementNamed(context, '/login');
    });

    _fetchPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 85,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MYRUNES',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text('version ${_packInfo?.version}')
                  ],
                ),
                decoration: BoxDecoration(color: Colors.pink),
              ),
            ),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                await apiInstance.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _HomePageContent(
        pages: _pages,
        onRefresh: () async {
          await _fetchData();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _fetchData() async {
    var pList = await apiInstance.getPages();
    setState(() {
      _pages = pList.data;
    });
  }

  Future<void> _fetchPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packInfo = info;
    });
  }
}
