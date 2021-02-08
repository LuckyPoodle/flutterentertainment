import 'package:amcollective/providers/roleprovider.dart';
import 'package:amcollective/screens/deals_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import 'package:provider/provider.dart';
import '../providers/roleprovider.dart';
import '../models/appuser.dart';
import '../models/deal.dart';
import '../screens/dealbycondition.dart';

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
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
 Image(fit: BoxFit.contain,height: 50,
  image: NetworkImage('https://media.publit.io/file/cybermonday.jpeg'),),
            

           SizedBox(
              height: 10,

            ),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
              children: <Widget>[
                
                Container(
                  decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('North'),onPressed: (){
                    Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'North');
                  },),),

                   Container(
                  decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('South'),onPressed: (){
                     Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'South');
                  },),),

                    Container(
                  decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('East'),onPressed: (){
                     Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'East');
                  },),),

                    Container(
                  decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('West'),onPressed: (){
                     Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'West');
                  },),)

                

            ],),  
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('Central'),onPressed: (){
                    Navigator.of(context).pushNamed(DealsByConditionScreen.routeName,arguments:'Central');
                  },),),
              Container(
              width: width*0.5,
              height: 50,
              color: Colors.green,
              child:  FlatButton(onPressed: (){
              Navigator.of(context).pushNamed(DealsMapScreen.routeName);
            }
            
            , child:Text('MAP'),
            ))

            ],)


           
            ,
    for (Deal document in _documents)
    Card(
    
    child:Padding(
      padding: EdgeInsets.all(5),
      child:  Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
           Image(
             fit: BoxFit.contain,
  image: NetworkImage(document.imageUrl),
),
    ListTile(
    leading: Icon(Icons.money, size: 50),
    title: Text(document.dealname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
    subtitle: Text(document.dealdetails,style: TextStyle(fontSize: 15),),
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