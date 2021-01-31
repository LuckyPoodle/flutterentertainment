import 'package:amcollective/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Hello Friend!'),
              // below means will never show a back button
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.perm_identity),
              title: Text('Login/Register'),
              onTap: () {
                //
                Navigator.of(context).pushNamed(AuthScreen.routeName);
              },
            ),
           
            Divider(),

          ],
        ),
      );

  }
}