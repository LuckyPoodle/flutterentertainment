import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
class Profile extends StatelessWidget {

  static const routeName='/profile';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:  Text('Profile '),
      ),
    );
  }
}