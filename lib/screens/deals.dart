import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
class Deals extends StatelessWidget {

  static const routeName='/deals';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:  Text('Deals '),
      ),
    );
  }
}