import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import '../screens/auth_screen.dart';
import '../utilities/authservice.dart';
import 'package:provider/provider.dart';
import './editdeal.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  static const routeName='/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 final AuthService auth = AuthService();



  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

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

    if (user != null) {
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
                itemBuilder: (ctx, index) => Container(child: Text(chatDocs[index].data()['text']),),
              );
      }, )
       ),

      ],)
    );


    

    }

  }
}