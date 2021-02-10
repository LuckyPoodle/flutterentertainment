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
    Card(
    
    child:Padding(
      padding: EdgeInsets.all(5),
      child:  Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
           Image(
             fit: BoxFit.contain,
  image: NetworkImage(document.imageUrl.isNotEmpty?document.imageUrl:document.imageUrlfromStorage.isNotEmpty?document.imageUrlfromStorage:''),
),
    ListTile(
    leading: Icon(Icons.money, size: 50),
    title: Text(document.dealname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
    subtitle: Text(document.dealdetails,style: TextStyle(fontSize: 15),),
    ),
    ],
    ),),
    
    ),
    ],
    ),
    )
      ],),
      
    );
  }
}