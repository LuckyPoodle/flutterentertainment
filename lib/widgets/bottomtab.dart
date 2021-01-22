import 'package:flutter/material.dart';

class BottomTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
                size: 30.0,
                color: Colors.black,
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                size: 30.0,
                color: Colors.grey,
              ),
              title: Text(''),
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.videogame_asset,
                size: 30.0,
                color: Colors.grey,
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 30.0,
                color: Colors.grey,
              ),
              title: Text(''),
            ),
          ],
        ));
  }
}