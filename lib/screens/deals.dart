import 'package:amcollective/providers/roleprovider.dart';
import 'package:amcollective/screens/branddetail.dart';
import 'package:amcollective/screens/deals_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import 'package:provider/provider.dart';
import '../providers/roleprovider.dart';
import '../models/appuser.dart';
import '../models/deal.dart';
import '../screens/dealbycondition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Deals extends StatefulWidget {

  static const routeName='/deals';

  @override
  _DealsState createState() => _DealsState();
}

class _DealsState extends State<Deals> {
AppUser appuser;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('------ in deals.dart initstate');
    appuser=Provider.of<RoleProvider>(context,listen: false).currentuser;
    if (appuser.brandname=='username')Provider.of<RoleProvider>(context,listen: false).getUserData();
  }


  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    AppUser appuser=Provider.of<RoleProvider>(context).currentuser;
    List<Deal> _documents = Provider.of<List<Deal>>(context);
    if (_documents == null) {
      return Center(child: Text('No Deals yet, please check back!'));
    }
    

    return Scaffold(
      backgroundColor: ThemeData().backgroundColor,
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[



 Image(fit: BoxFit.cover,height: 150,width: width,
  image: NetworkImage('https://media.publit.io/file/deals.jpeg'),),
            

           SizedBox(
              height: 10,

            ),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
              children: <Widget>[
                
                Container(
                  decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('North',style: TextStyle(color: Colors.white)),onPressed: (){
                    Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'North');
                  },),),

                   Container(
                  decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('South',style: TextStyle(color: Colors.white),),onPressed: (){
                     Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'South');
                  },),),

                    Container(
                  decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('East',style: TextStyle(color: Colors.white)),onPressed: (){
                     Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'East');
                  },),),

                    Container(
                  decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('West',style: TextStyle(color: Colors.white)),onPressed: (){
                     Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'West');
                  },),)

                

            ],),  
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: width*0.45,
                  decoration: BoxDecoration(
                  color: Colors.black,

                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('Central',style: TextStyle(color: Colors.white)),onPressed: (){
                    Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'Central');
                  },),),
              Container(
              width: width*0.45,
              height: 50,
              decoration: BoxDecoration(

                image: DecorationImage(
                  fit: BoxFit.fitWidth,

                  image: AssetImage('assets/images/map.jpg',)
                )
              ),

              child:  FlatButton(

                onPressed: (){
              Navigator.of(context).pushNamed(DealsMapScreen.routeName);
            }
            
            , child:Text('MAP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ))

            ],),
          SizedBox(height: 5,),

          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: 5,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white,
                ),
                child: Center(child: Text('All Deals',style: TextStyle(color: Colors.black),)),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: 5,
                ),
              ),
            ],
          ),

        SizedBox(height: 5,),
           

    for (Deal document in _documents)
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
          child:  Text(document.brandname,style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
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

SizedBox(
              height: 100,

            ),

    ],  
        ),
    
      ),
    );
  }
}