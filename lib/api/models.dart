abstract class Mapable {
  Map<String, dynamic> toMap();
}

class ErrorResponse {
  final String message;
  final int code;

  ErrorResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        code = json['code'];
}

class ListResponse<T> {
  ListResponse({this.n, this.data});

  final int n;
  final List<T> data;
}

class UserModel implements Mapable {
  String uid;
  String username;
  String mailaddress;
  String displayname;
  DateTime lastlogin;
  DateTime created;
  List<String> favorites;
  Map<String, List<String>> pageorder;

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    mailaddress = json['mailaddress'];
    displayname = json['displayname'];

    lastlogin = DateTime.parse(json['lastlogin']);
    created = DateTime.parse(json['created']);

    favorites = _asList(json['favorites']);

    if (json['pageorder'] != null) {
      pageorder = (json['pageorder'] as Map<String, dynamic>)
          .map<String, List<String>>((k, v) => MapEntry(k,
              (v as List<dynamic>).map<String>((lv) => lv as String).toList()));
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'mailaddress': mailaddress,
      'displayname': displayname,
      'lastlogin': lastlogin,
      'created': created,
      'favorites': mailaddress,
      'pageorder': pageorder,
    };
  }
}

class TreeModel implements Mapable {
  TreeModel({this.tree, this.rows});

  String tree;
  List<String> rows;

  TreeModel.fromJson(Map<String, dynamic> json) {
    tree = json['tree'];
    rows = _asList(json['rows']);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tree': tree,
      'rows': rows,
    };
  }
}

class PerksModel implements Mapable {
  List<String> rows;

  PerksModel.fromJson(Map<String, dynamic> json) {
    rows = _asList(json['rows']);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rows': rows,
    };
  }
}

class PageModel implements Mapable {
  String uid;
  String owner;
  String title;
  DateTime created;
  DateTime edited;
  List<String> champions;
  TreeModel primary;
  TreeModel secondary;
  PerksModel perks;

  PageModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    owner = json['owner'];
    title = json['title'];

    created = DateTime.parse(json['created']);
    edited = DateTime.parse(json['edited']);

    champions = _asList(json['champions']);

    primary = TreeModel.fromJson(json['primary']);
    secondary = TreeModel.fromJson(json['secondary']);
    perks = PerksModel.fromJson(json['perks']);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'owner': owner,
      'title': title,
      'created': created.toIso8601String(),
      'edited': edited.toIso8601String(),
      'champions': champions,
      'primary': primary.toMap(),
      'secondary': secondary.toMap(),
      'perks': perks.toMap(),
    };
  }
}

class Champion {
  String uid, name;

  Champion.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
  }
}

class Rune {
  String uid, name, shortDesc, longDesc;

  Rune.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    shortDesc = json['shortDesc'];
    longDesc = json['longDesc'];
  }
}

class Slot {
  List<Rune> runes;

  Slot.fromJson(Map<String, dynamic> json) {
    if (json['runes'] != null) {
      runes =
          (json['runes'] as List).map<Rune>((e) => Rune.fromJson(e)).toList();
    }
  }
}

class Tree {
  String uid, name;
  List<Slot> slots;

  Tree.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];

    if (json['slots'] != null) {
      slots = (json['slots'] as List).map((e) => Slot.fromJson(e)).toList();
    }
  }
}

class RunesInfoModel {
  List<List<String>> perks;
  List<Tree> trees;

  RunesInfoModel.fromJson(Map<String, dynamic> json) {
    if (json['perks'] != null) {
      perks =
          (json['perks'] as List).map<List<String>>((e) => _asList(e)).toList();
    }

    if (json['trees'] != null) {
      trees = (json['trees'] as List).map((e) => Tree.fromJson(e)).toList();
    }
  }
}

class ViewerEditorArguments {
  ViewerEditorArguments({this.page, this.pageList});

  PageModel page;
  final List<PageModel> pageList;
}

List<T> _asList<T>(List<dynamic> list) {
  if (list == null) return List<T>();
  return list.map((e) => e as T).toList();
}
