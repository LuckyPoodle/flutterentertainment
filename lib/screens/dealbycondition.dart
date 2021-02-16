import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dealprovider.dart';
import '../models/deal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:amcollective/screens/branddetail.dart';
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

            child:Padding(
              padding: EdgeInsets.all(5),
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(BrandDetailScreen.routeName,arguments:document.createdBy);


                      },
                      child:Container(
                        alignment: Alignment.topLeft,
                        child:  Text(document.brandname,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                      )
                  ),


                  Container(
                    padding: EdgeInsets.only(left:15,bottom: 10),
                    alignment: Alignment.topLeft,
                    child:  Text(document.location,style: TextStyle(fontSize: 20, ),),
                  ),
                  Image(
                    fit: BoxFit.contain,
                    image: NetworkImage(document.imageUrl.isNotEmpty?document.imageUrl:document.imageUrlfromStorage.isNotEmpty?document.imageUrlfromStorage:''),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.handHoldingUsd),
                    title: Text(document.dealname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                    subtitle: Text(document.dealdetails,style: TextStyle(fontSize: 25),),
                  ),
                ],
              ),),

          ),

      ],),
      
    );
  }
}