import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class MainPage extends StatefulWidget {
  final MainModel model;

  MainPage(this.model);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  String appTitle = 'Mobile Sales';

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  void _onTaped(int index) {
    print(index);
    setState(() {
      _currentIndex = index;
      if (index == 2) {
        appTitle = 'Mobile Sales';
      }
      if (index == 3) {
        _logout();
      }
    });
  }

  void _logoutaction(Function logout) async {
    Map<String, dynamic> successInformation;
    successInformation = await logout();
    if (successInformation['success']) {
      print('logout success');
      Navigator.of(context).pop();
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          return AlertDialog(
            title: Text(
              'ยืนยันการออกจากระบบ!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "คุณต้องการออกจากระบบใช่หรือไม่",
              style: TextStyle(color: Colors.red),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ใช่',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => _logoutaction(model.logout),
              ),
              FlatButton(
                child: Text('ไม่ใช่',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [null, null, null];
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     appTitle,
      //     style: TextStyle(fontFamily: 'Cloud-Bold'),
      //   ),
      //   actions: <Widget>[
      //     IconButton(
      //       //color: Colors.white,
      //       icon: Icon(
      //         Icons.search,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         // showSearch(context: context, delegate: DataSearch());
      //       },
      //     ),
      //     // IconButton(
      //     //   //color: Colors.white,
      //     //   onPressed: (){},
      //     //   icon: Icon(
      //     //     Icons.favorite_border,
      //     //     color: Colors.white,
      //     //   ),
      //     // ),
      //     // IconButton(
      //     //     //color: Colors.white,
      //     //     icon: Icon(Icons.shopping_cart, color: Colors.white),
      //     //     onPressed: () {
      //     //       // Navigator.push(context,
      //     //       //     MaterialPageRoute(builder: (context) => CardPage()));
      //     //     }),
      //   ],
      // ),
      body: tabs[_currentIndex],
      // TabBarView(
      //     children: <Widget>[
      //        UserProfile(),
      //       ProductGridPage(widget.model),
      //       ProductGridPage(widget.model),

      //     ],
      //     controller: _tabController,
      //   ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTaped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title:
                  Text('Profile', style: TextStyle(fontFamily: 'Cloud-Bold'))),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Jobs', style: TextStyle(fontFamily: 'Cloud-Bold'))),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            title: Text('Exit', style: TextStyle(fontFamily: 'Cloud-Bold')),
          ),
        ],
      ),
    );
  }
}
