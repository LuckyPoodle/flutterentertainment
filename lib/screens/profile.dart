import 'package:amcollective/providers/roleprovider.dart';
import 'package:amcollective/screens/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import 'package:flutter_html/style.dart';
import '../screens/auth_screen.dart';
import '../utilities/authservice.dart';
import 'package:provider/provider.dart';
import './editdeal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appuser.dart';
import '../screens/editdeal.dart';
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

    print('user-----');
    final user = Provider.of<RoleProvider>(context,listen: false);
    print(user.mycurrentuser.brandname);
    print("---------");

  }


  @override
  Widget build(BuildContext context) {
   final width=MediaQuery.of(context).size.width;
    User user = Provider.of<User>(context);
    print('in profile build....');
    print(user);
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
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.all(16.0),
            child:  Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                  NetworkImage(thisappuser.profileimg!=null?thisappuser.profileimg:'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 10,),
                Column(children: <Widget>[
                  Text(thisappuser.brandname,style: TextStyle(fontWeight: FontWeight.bold,fontSize:30),),
                  Container(
                    width: width*0.5,
                    child: Text(thisappuser.description),
                  ),
                  Text('Location(s)'),
                  for (var address in thisappuser.outletlist)
                    Text(address.address)

                ],)

                ,

              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                width: width*0.5,
                child: FlatButton(


                    child: Text('Edit Profile'),
                    color: Colors.blue,
                    onPressed: () async {

                      Navigator.of(context).pushNamed(EditProfileScreen.routeName,arguments:thisappuser);
                    }),
              ),
              Container(
                width: width*0.5,
                padding: EdgeInsets.all(5.0),
                child: FlatButton(

                    child: Text('Log Out'),
                    color: Colors.red,
                    onPressed: () async {
                      await auth.signOut();
                      roleprovider.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }),
              ),
            ],
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
                                    trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {
                                      Navigator.of(context).pushNamed(EditDealScreen.routeName,arguments:chatDocs[index].id);
                                    },),
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
                        Navigator.of(context).pushNamed(EditDealScreen.routeName );

                      }),
                ),
              SizedBox(
                height: 80,
              )

              ],
            )


        ],),
      )
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