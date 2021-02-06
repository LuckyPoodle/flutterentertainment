import 'package:amcollective/providers/roleprovider.dart';
import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import 'package:provider/provider.dart';
import '../providers/roleprovider.dart';
import '../models/appuser.dart';
import '../models/deal.dart';


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
    AppUser appuser=Provider.of<RoleProvider>(context).currentuser;
    List<Deal> _documents = Provider.of<List<Deal>>(context);
    if (_documents == null) {
      return Center(child: Text('No Deals yet, please check back!'));
    }
    

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child:  appuser.brandname=='username'?Text('Deals '):Text('deals for '+appuser.brandname),
          ),
    for (Deal document in _documents)
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



    ],
      ),
    );
  }
}