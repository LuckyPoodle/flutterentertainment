import 'package:amcollective/screens/consolidated.dart';
import 'package:amcollective/screens/deals.dart';
import 'package:amcollective/screens/games_overall.dart';
import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../providers/selected_category.dart';
import '../screens/blogpage.dart';
import '../screens/game.dart';
import '../screens/profile.dart';
import '../widgets/drawer.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/';
  int myselectedpage=0;

  TabsScreen(this.myselectedpage);



  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
 // int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': Consolidated(),
        'title': 'Blog Posts',
      },
      {
        'page':Deals() ,
        'title': 'Deals',
      },
      {
        'page':GamesOverallScreen() ,
        'title': 'Game',
      },
      {
        'page':Profile() ,
        'title': 'profile',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      widget.myselectedpage=index;
      //_selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _page = 0;
    GlobalKey _bottomNavigationKey = GlobalKey();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu,color: Colors.white,),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
          flexibleSpace: Container(
            alignment: Alignment.center,
            color: Colors.black
            ,
            child: Text('AMCOLLECTIVE',style: TextStyle(
              color: Colors.white,
              letterSpacing: 5.0,
              fontSize: 30.0,
              fontWeight: FontWeight.bold
            ),),
          )
      ),

      body: Stack(children: <Widget> [
        _pages[widget.myselectedpage]['page'],

        Positioned(left:0,right:0,bottom:0,child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: widget.myselectedpage,
          height: 60.0,
          items: <Widget>[
        Icon(Icons.dashboard, size: 30,color: Colors.white,),
        Icon(Icons.star, size: 30,color: Colors.white,),
        Icon(Icons.videogame_asset, size: 30,color: Colors.white,),
        Icon(Icons.perm_identity, size: 30,color: Colors.white,),
          ],
          color: Colors.black,
          buttonBackgroundColor: Colors.black,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: _selectPage,
          letIndexChange: (index) => true,
        ),)
      ],),

    );
  }
}









//class BottomTab extends StatelessWidget {
//
//
//  @override
//  Widget build(BuildContext context) {
//    var controlindex = Provider.of<SelectedCategory>(context);
//    int _page=controlindex.selectedIndex;
//    GlobalKey _bottomNavigationKey=GlobalKey();
//    return CurvedNavigationBar(
//      key: _bottomNavigationKey,
//      index: 0,
//      height: 50.0,
//      items: <Widget>[
//        Icon(Icons.dashboard, size: 30,color: Colors.white,),
//        Icon(Icons.star, size: 30,color: Colors.white,),
//        Icon(Icons.videogame_asset, size: 30,color: Colors.white,),
//        Icon(Icons.perm_identity, size: 30,color: Colors.white,),
//
//      ],
//      color: Colors.black,
//      buttonBackgroundColor: Colors.black,
//      backgroundColor: Colors.white,
//      animationCurve: Curves.easeInOut,
//      animationDuration: Duration(milliseconds: 600),
//      onTap: (index) {
//
//       controlindex.changeSelectedIndex(index);
//       if (index==0){
//         Navigator.of(context).pushReplacementNamed('/');
//
//       }else if (index==1){
//        // Navigator.of(context).pushReplacementNamed(Deals.routeName);
//       }
//      },
//      letIndexChange: (index) => true,
//    );
//
//  }
//}

//    return ClipRRect(
//        borderRadius: BorderRadius.only(
//          topLeft: Radius.circular(30.0),
//          topRight: Radius.circular(30.0),
//        ),
//        child: BottomNavigationBar(
//          type: BottomNavigationBarType.fixed,
//          items: [
//            BottomNavigationBarItem(
//              icon: Icon(
//                Icons.dashboard,
//                size: 30.0,
//                color: Colors.black,
//              ),
//              title: Text(''),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(
//                Icons.star,
//                size: 30.0,
//                color: Colors.grey,
//
//              ),
//              label: 'Deal',
//
//
//            ),
//
//            BottomNavigationBarItem(
//              icon: Icon(
//                Icons.videogame_asset,
//                size: 30.0,
//                color: Colors.grey,
//              ),
//              title: Text(''),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(
//                Icons.person_outline,
//                size: 30.0,
//                color: Colors.grey,
//              ),
//              title: Text(''),
//            ),
//          ],
//        ))


//decoration: BoxDecoration(
//gradient: LinearGradient(
//colors: [Colors.blueGrey, Colors.black],
//begin: Alignment.bottomRight,
//end: Alignment.topLeft,
//),
//
//)