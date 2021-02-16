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
import 'package:async/async.dart';
import '../screens/editdeal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  User user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService auth = AuthService();
//  AppUser thisappuser=AppUser(
//    brandname: 'username',
//    dealsbybusiness: [],
//    description: 'account description',
//    outletlist: [],
//    isBrand: false,
//    imageUrlfromStorage: ''

//  );

  int loadcount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('IN PROFILE init state!!!');
    widget.user = Provider.of<User>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scaffold = Scaffold.of(context);
    User user = Provider.of<User>(context);
    print('in profile build....');
    print(user);
    RoleProvider roleprovider =
        Provider.of<RoleProvider>(context, listen: false);
    final AsyncMemoizer _memoizer = AsyncMemoizer();
    //thisappuser=roleprovider.currentuser;

    if (user == null) {
      return Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30),
            child: Text('Not logged in',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: FlatButton(
                child: Text('Login'),
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).pushNamed(AuthScreen.routeName);
                }),
          ),
        ],
      ));
    }

    return Scaffold(
        body: SingleChildScrollView(
            child:

            FutureBuilder(
      future: Provider.of<RoleProvider>(context, listen: false).getUserData(),
      builder: (context, thisappuser) {
        if (!thisappuser.hasData) {
          return Center(
            child: SpinKitChasingDots(
              color: Colors.black,
              size: 100.0,
            ),
          );
        } else {
          if (thisappuser.data.isBrand) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            fit: BoxFit.contain,
                            image: NetworkImage(thisappuser
                                    .data.profileimg.isNotEmpty
                                ? thisappuser.data.profileimg
                                : 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            Container(
                            width: width * 0.5,
                            child:  Text(
                            thisappuser.data.brandname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          ),

                          Container(
                            width: width * 0.5,
                            child: Text(thisappuser.data.description),
                          ),
                          Container(
                            width: width * 0.5,
                            child:  Text(
                            'Location (s)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          ),
                          if (thisappuser.data.outletlist.isNotEmpty)
                            for (var address in thisappuser.data.outletlist)
                              Container(
                            width: width * 0.5,
                            child:  Text(
                            address.address,
                            style: TextStyle(

                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: width * 0.5,
                      child: FlatButton(
                          child: Text('Edit Profile'),
                          color: Colors.lightBlue,
                          onPressed: () async {
                            Navigator.of(context).pushNamed(
                                EditProfileScreen.routeName,
                                arguments: thisappuser.data);
                          }),
                    ),
                    Container(
                      width: width * 0.5,
                      padding: EdgeInsets.all(5.0),
                      child: FlatButton(
                          child: Text('Log Out'),
                          color: Colors.red,
                          onPressed: () async {
                            await auth.signOut();
                            roleprovider.signOut();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (route) => false);
                          }),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Your Submitted Deals'),
                    ),
                    Container(
                        child: StreamBuilder(
                      stream: auth.getBrandDeal(user.uid),
                      builder:
                          (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black,
                            ),
                          );
                        }
                        final chatDocs = chatSnapshot.data.docs;
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                elevation: 4,
                                margin: EdgeInsets.all(4),
                                child: ListTile(
                                  title:
                                      Text(chatDocs[index].data()['dealname']),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        chatDocs[index].data()['imageUrl']),
                                  ),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                EditDealScreen.routeName,
                                                arguments: chatDocs[index].id);
                                          },
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            try {
                                              print('to delete.....');
                                              print(chatDocs[index].id);
                                              auth.deleteDeal(
                                                  chatDocs[index].id,
                                                  chatDocs[index].data()[
                                                      'imageUrlfromStorage']);
                                            } catch (error) {
                                              //Scaffold.of(context) can't work here as u r updating widget tree, so we use
                                              scaffold.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Deleting failed!',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          color: Theme.of(context).errorColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                )));
                      },
                    )),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FlatButton(
                          child: Text('Add Deal'),
                          color: Colors.lightBlue,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EditDealScreen.routeName);
                          }),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                )
              ],
            );
          } else {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(thisappuser
                                .data.imageUrlfromStorage.isNotEmpty
                            ? thisappuser.data.imageUrlfromStorage
                            : 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            thisappuser.data.brandname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width * 0.5,
                      padding: EdgeInsets.all(5.0),
                      child: FlatButton(
                          child: Text('Log Out'),
                          color: Colors.red,
                          onPressed: () async {
                            await auth.signOut();
                            roleprovider.signOut();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (route) => false);
                          }),
                    ),
                  ],
                ),
              ],
            );
          }
        }
      },
    )));
  }
}
