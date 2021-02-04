import 'package:amcollective/providers/roleprovider.dart';
import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import '../screens/auth_screen.dart';
import '../utilities/authservice.dart';
import 'package:provider/provider.dart';
import './editdeal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  static const routeName='/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 final AuthService auth = AuthService();
 AppUser thisappuser=AppUser(
   brandname: 'username',
   dealsbybusiness: [],
   description: 'account description',
   outletlist: [],
   isBrand: false

 );

 int loadcount=0;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('IN PROFILE init state!!!');
    print(Provider.of<RoleProvider>(context,listen: false).currentuser.brandname);
    if (Provider.of<RoleProvider>(context,listen: false).currentuser.brandname=='username'){
      Provider.of<RoleProvider>(context,listen: false).getUserData().then((value){
        thisappuser=value;
      });
    }else{
      thisappuser=Provider.of<RoleProvider>(context,listen: false).currentuser;
    };

  }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    RoleProvider roleprovider=Provider.of<RoleProvider>(context);
    thisappuser=roleprovider.currentuser;

    if (user==null){
      return Scaffold(
        body: Container(
          child:  FlatButton(
              child: Text('Login'),
              color: Colors.red,
              onPressed: () {

                Navigator.of(context).pushNamed(AuthScreen.routeName);
              }),
        ),
      );
    }

   if (user!=null) {

      return Scaffold(
      body: Column(children: [
        Padding(
        padding: EdgeInsets.all(16.0),
        child:  Row(
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundImage:
              NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/330px-SNice.svg.png"),
              backgroundColor: Colors.transparent,
            ),
Column(children: <Widget>[
  Text('username')
],)

,
            FlatButton(
                child: Text('logout'),
                color: Colors.red,
                onPressed: () async {
                  await auth.signOut();
                  roleprovider.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                })
          ],
        ),
      ),Padding(
          padding: EdgeInsets.all(20),
          child: Text(thisappuser.brandname),
        ),

     if (thisappuser.isBrand)
        Column(
          children: <Widget>[ Padding(
            padding: EdgeInsets.all(20),
            child: Text('Your Submitted Deals'),
          ),

            Container(
                child: StreamBuilder(
                  stream:auth.getBrandDeal(user.uid),
                  builder:(ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                    if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(backgroundColor: Colors.black,),
                      );
                    }
                    final chatDocs = chatSnapshot.data.docs;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatDocs.length,
                        //Text(chatDocs[index].data()['dealname']),
                        itemBuilder: (ctx, index) => Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          elevation: 4,
                          margin: EdgeInsets.all(4),
                          child: InkWell(
                            onTap: () {

                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: ListTile(
                                title: Text(
                                  chatDocs[index].data()['dealname'],
                                  style: Theme.of(context).textTheme.title,
                                ),
                                subtitle: Text(
                                  chatDocs[index].data()['dealdetails'],
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.subhead,
                                ),
                                trailing: IconButton(icon: Icon(Icons.edit),),
                              ),
                            ),
                          ),
                        )
                    );
                  }, )
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child:  FlatButton(
                  child: Text('add deal'),
                  color: Colors.blue,
                  onPressed: ()  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDealScreen(
                            user.uid
                        ),
                      ),
                    );

                  }),
            ),],
        )


      ],)
    );


    

    }else{
      return Scaffold(
        body: Column(children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child:  FlatButton(
                child: Text('logout'),
                color: Colors.red,
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                }),
          ),
         Text('USER')

        ],)
      );
    }

  }
}