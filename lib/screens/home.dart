import 'package:myrunes/api/api.dart';
import 'package:myrunes/api/models.dart';
import 'package:myrunes/widgets/pagetile.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:package_info/package_info.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.apiInstance}) : super(key: key);

  final String title;
  final API apiInstance;

  @override
  _HomeScreenState createState() => _HomeScreenState(apiInstance);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.apiInstance);

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
                      style: const TextStyle(fontSize: 25),
                    ),
                    Text('version ${_packInfo?.version}')
                  ],
                ),
                decoration: const BoxDecoration(color: Colors.pink),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.settings), title: Text('Settings')),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                await apiInstance.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _HomeScreenContent(
        pages: _pages,
        onRefresh: () async {
          await _fetchData();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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

class _HomeScreenContent extends StatelessWidget {
  _HomeScreenContent({this.pages, this.onRefresh});

  final List<PageModel> pages;
  final Future<void> Function() onRefresh;

  void _onPageTileTap(BuildContext context, PageModel page) {
    Navigator.pushNamed(context, '/pages/view', arguments: page);
  }

  @override
  Widget build(BuildContext context) {
    final pageWidgets = <Widget>[
      Container(
        height: 10,
      )
    ];
    pageWidgets.addAll(pages
        .map((e) => GestureDetector(
            child: PageTile(e), onTap: () => _onPageTileTap(context, e)))
        .toList());

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
