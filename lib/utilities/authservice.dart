import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/deal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/appuser.dart';
import '../models/address.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var userisBrand=false;
  AppUser appUser=AppUser(brandname: 'username',
    dealsbybusiness: [],
    isBrand: false,
    description: 'account description',
    outletlist: [],);

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Stream<AppUser> userData(String uid) {
    return users.doc(uid).snapshots().map((doc) {
      return AppUser.fromDocument(doc);
    });
  }



  // Firebase user a realtime stream

// Firebase user one-time fetch
//bool isLoggedIn(){
//  return _auth.currentUser!=null;
//}

Stream<User> get user => FirebaseAuth.instance.authStateChanges();



  /// Sign in with Google
   Future<UserCredential> signInWithGoogle() async {
            print('sign in with google ----');
          // Trigger the authentication flow
          final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

          // Obtain the auth details from the request
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          // Create a new credential
          final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
        UserCredential result = await _auth.signInWithCredential(credential);




        if (result.additionalUserInfo.isNewUser==true){
          addUserData(result);
        }



          // Once signed in, return the UserCredential
          return result;
}

Future<UserCredential> signInWithEmail(String email, String password) async{
try{
  UserCredential authResult = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );



  return authResult;
}on FirebaseAuthException catch (e) {
  print('firebaseauthexception');
  print(e);

} catch (e) {
  print('sign in error');
  print(e);
}

}

Future<UserCredential> registerWithEmail(String email, String password) async{
  try {
  UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password
  );


  if (userCredential.additionalUserInfo.isNewUser==true){
    addUserData(userCredential);
  }


  return userCredential;
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
}




  
  void addUserData(UserCredential user) async{


      await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user.uid)
            .set({
        'brandname':user.user.displayName,
        'profileimg':'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/330px-SNice.svg.png',
        'description':'Brand description',
        'outletlist':[],
        'isBrand':false,
        'dealsbybusiness':[],
        'role':'public',

        });

  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<bool> addDeal(Deal deal) async{
    await FirebaseFirestore.instance.collection('deals').add({

      'createdAt': Timestamp.now(),
      'userId': _auth.currentUser.uid,
      'dealname':deal.dealname,
      'dealdetails':deal.dealdetails,
      'location':deal.location,
      'imageUrl':deal.imageUrl,
      'longitude':deal.longitude,
      'latitude':deal.latitude
    }) .then((value){
      print('added deal!!!!!!!!!!!!!');
      return true;
    })
        .catchError((error)  {
          print(error);
          print('not added');
          return false;
    });
  }

  Future<bool> updateDeal(Deal deal) async{
    await FirebaseFirestore.instance.collection('deals').doc(deal.id).set({
       'updatedAt':Timestamp.now(),
      'userId': _auth.currentUser.uid,
      'dealname':deal.dealname,
      'dealdetails':deal.dealdetails,
      'location':deal.location,
      'imageUrl':deal.imageUrl,
      'longitude':deal.longitude,
      'latitude':deal.latitude
    },SetOptions(merge: true)) .then((value){
      print('updated deal!!!!!!!!!!!!!');
      return true;
    })
        .catchError((error)  {
      print(error);
      print('not added');
      return false;
    });
  }

  Stream<QuerySnapshot> getBrandDeal(String id) {
  Stream<QuerySnapshot> q= _db.collection('deals').where('userId',isEqualTo: id ).snapshots();
  print(q);
  print('==============in getbranddeal=====================');
  return q;
}
  Stream<DocumentSnapshot> getUserStream() {
    Stream<DocumentSnapshot> q= _db.collection('users').doc(_auth.currentUser.uid).snapshots();
    print(q);
    print('==============in getprofile=====================');
    return q;
  }

  Stream<QuerySnapshot> getAllDeals() {

    Stream<QuerySnapshot> q= _db.collection('deals').snapshots();
    print(q);
    print('==============in getALLDEALS=====================');
    return q;
  }

  Future<bool> updateUser(AppUser appuser) async{
     print('in updateUser');


    await FirebaseFirestore.instance.collection('users').doc(appuser.id).set(appuser.toMap(),SetOptions(merge: true))
        .then((value){
      print('updated user!!!!!!!!!!!!!');
      return true;
    })
        .catchError((error)  {
      print(error);

      print('not added');
      return false;
    });
  }


Future<AppUser> getAppUserData() async{
  print('_______________________________________________in authservice getappuserdata__________________________________________________________');
     if (_auth.currentUser!=null){
       print('_______________________________________________in authservice USER IS LOGGED IN__________________________________________________________');
       var snapshot=await _db.collection('users').doc(_auth.currentUser.uid).get();
       print(snapshot);
       var data=snapshot.data();
       var isbrand=data['role']=='brand';
       String brandname=data['brandname'];
       String description=data['description'];
       String profileimg=data['profileimg'];
       var outlistlist=(data['outletlist'] as List??[]).map((v)=>PlaceLocation.fromMap(v)).toList();
       print('outletlist');
       print(outlistlist);
       print(outlistlist[0]);

       //(data['quizzes'] as List ?? []).map((v) => Quiz.fromMap(v)).toList(),
       var dealsbybusiness=data['dealsbybusiness'];
       AppUser thisuser=AppUser(
           description: description,
           isBrand: isbrand,
           brandname: brandname,
           outletlist: outlistlist,
           dealsbybusiness:[],
            id:_auth.currentUser.uid,
         profileimg:profileimg ,

       );
       appUser=thisuser;

       return thisuser;
     }else{
       print('_______________________________________________NO USER LOGGED IN __________________________________________________________');
       return AppUser(brandname: 'username',
         dealsbybusiness: [],
         description: 'account description',
         isBrand: false,
         outletlist: [],);
     }
}

Future<AppUser> fetchupdateduser() async{
  var snapshot=await _db.collection('users').doc(_auth.currentUser.uid).get();
  print(snapshot);
  var data=snapshot.data();
  var isbrand=data['role']=='brand';
  String brandname=data['brandname'];
  String description=data['description'];
  String profileimg=data['profileimg'];

  var outlistlist=(data['outletlist'] as List??[]).map((v)=>PlaceLocation.fromMap(v)).toList();
  print('outletlist');
  print(outlistlist);
  print(outlistlist[0]);

  //(data['quizzes'] as List ?? []).map((v) => Quiz.fromMap(v)).toList(),
  var dealsbybusiness=data['dealsbybusiness'];
  AppUser thisuser=AppUser(
      description: description,
      isBrand: isbrand,
      brandname: brandname,
      outletlist: outlistlist,
      profileimg:profileimg ,
      dealsbybusiness:[],
      id:_auth.currentUser.uid


  );
  appUser=thisuser;

  return thisuser;
}



}
