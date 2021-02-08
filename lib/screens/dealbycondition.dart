import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dealprovider.dart';
import '../models/deal.dart';
class DealsByConditionScreen extends StatelessWidget {

  static const routeName='/dealsbycondition';

  @override
  Widget build(BuildContext context) {
    final region=ModalRoute.of(context).settings.arguments as String;
    List<Deal> listofdeals=Provider.of<DealProvider>(context,listen: false).getDealsFrom(region);

    return Scaffold(
      appBar:AppBar(automaticallyImplyLeading: true,title: Text('Deals in the $region'),),
      body: Column(children: <Widget>[
        SizedBox(height: 20,),
        for (Deal document in listofdeals)
    Card(
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    ListTile(
    leading: Icon(Icons.album, size: 50),
    title: Text(document.dealname),
    subtitle: Text(document.dealdetails),
    ),
    ],
    ),
    )
      ],),
      
    );
  }
}