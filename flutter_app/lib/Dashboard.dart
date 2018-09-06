import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/fragments/ManageNews.dart';
import 'package:flutter_app/fragments/MyProfile.dart';
import 'package:flutter_app/fragments/SecondFragment.dart';
import 'package:flutter_app/fragments/ManageEvents.dart';
import 'package:flutter_app/AddAndEditEventDetail.dart';
import 'package:flutter_app/AddAndEditNewsDetail.dart';
import 'package:flutter_app/fragments/ManageAthletics.dart';
import 'package:flutter_app/AddAndEditAthletic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/fragments/AddStudentAndParent.dart';
import 'package:flutter_app/fragments/StudentList.dart';
import 'package:flutter_app/fragments/FragmentClassList.dart';

class DrawerItem {
  String title;
  IconData iconData;

  DrawerItem(this.title, this.iconData);
}

bool visibilityTag = false;

class Dashboard extends StatefulWidget {
  static String tag = 'dashboard-page';

  final drawerItem = [
    new DrawerItem("My Profile", Icons.person),
    new DrawerItem("Assign Grades", Icons.account_balance),
    new DrawerItem("Add Parents And Student", Icons.add),
    new DrawerItem("Student List", Icons.person),
    new DrawerItem("Manage Events", Icons.adjust),
    new DrawerItem("Manage News", Icons.work),
    new DrawerItem("Manage Athletics", Icons.widgets),
    new DrawerItem("Chat Messages", Icons.chat),
    new DrawerItem("Map Of School", Icons.wifi),
    new DrawerItem("Change Password", Icons.warning),
    new DrawerItem("Logout", Icons.lock)
  ];

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedDrawerIndex = 0;
  String _userName;
  String _userProfile;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _userName = preferences.getString('user_name');
      _userProfile = preferences.getString('user_profile');
    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        setState(() {
          visibilityTag = false;
          MyProfileState.editable = "Non";
        });
        return new MyProfile();

      case 1:
        return new FragmentClassList();

      case 2:
        return new AddStudentAndParent();

      case 3:
        return new StudentList();

      case 4:
        setState(() {
          visibilityTag = true;
        });
        return new ManageEvents();

      case 5:
        setState(() {
          visibilityTag = true;
        });
        return new ManageNews();

      case 6:
        setState(() {
          visibilityTag = true;
        });
        return new ManageAthletics();

      case 10:
        return _openDialogLogout();

      default:
        return new Text('Error');
    }
  }

  Future _openDialogLogout() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you really want to logout?'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
      Navigator.of(context).pop(); //close drawer
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawerOption = <Widget>[];
    for (var i = 0; i < widget.drawerItem.length; i++) {
      var d = widget.drawerItem[i];
      drawerOption.add(
          new ListTile(
            leading: new Icon(d.iconData),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    _clickOnAddIcon() {
      if (widget.drawerItem[_selectedDrawerIndex].title == 'Manage Events') {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddAndEditEventDetail()));
      } else
      if (widget.drawerItem[_selectedDrawerIndex].title == 'Manage News') {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddAndEditNewsDetail()));
      } else
      if (widget.drawerItem[_selectedDrawerIndex].title == 'Manage Athletics') {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddAndEditAthletic()));
      } else if (widget.drawerItem[_selectedDrawerIndex].title ==
          'My Profile') {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyProfile()));
        MyProfileState.editable = "edit";
      }
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.drawerItem[_selectedDrawerIndex].title,),
        actions: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: new GestureDetector(
              onTap: () {
                _clickOnAddIcon();
              },
              child: visibilityTag == true ?
              new Icon(Icons.add) : Icon(Icons.edit),
            ),
          ),
        ],
      ),

      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: _userProfile == null ?
              new Image.asset(
                'assets/ic_launcher_launch.png',) :
              Image.network(
                  'http://182.72.79.154/p1136/media/front/img/user-profile-pictures/' +
                      _userProfile),
              accountName: new Text(_userName, textScaleFactor: 1.4),
              accountEmail: Text(''),
            ),
            new Column(children: drawerOption),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}