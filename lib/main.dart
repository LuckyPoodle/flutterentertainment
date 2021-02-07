import 'package:amcollective/providers/roleprovider.dart';
import 'package:amcollective/screens/auth_screen.dart';
import 'package:amcollective/screens/blogpage.dart';
import 'package:amcollective/screens/editdeal.dart';
import 'package:amcollective/screens/editprofile.dart';
import 'package:amcollective/screens/game.dart';
import 'package:amcollective/screens/games_overall.dart';
import 'package:amcollective/screens/profile.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/selected_category.dart';
import 'screens/PostDetail.dart';
import 'screens/deals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './utilities/authservice.dart';
import 'models/appuser.dart';
import 'providers/roleprovider.dart';
import 'models/deal.dart';
import 'providers/dealprovider.dart';
import 'screens/editprofile.dart';


//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final dealsCollection=FirebaseFirestore.instance.collection('deals');
    final dealsDataStream=dealsCollection.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        return Deal.fromDocument(doc);
      }).toList();
    });

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create:(ctx)=>SelectedCategory()
          ),
          StreamProvider<User>.value(value: AuthService().user),
          /////

          StreamProvider<List<Deal>>(
            create: (context)=>dealsDataStream,
          ),
          ChangeNotifierProxyProvider<List<Deal>,DealProvider>(
              update: (_,deals,__){
                return DealProvider(deals);
              }),
          ChangeNotifierProxyProvider<User,RoleProvider>(
              update: (_,user,__) {
                AuthService as=AuthService();
                as.getAppUserData();

                return RoleProvider(as.appUser);
              }),
          ProxyProvider<User, Stream<AppUser>>(update: (_, user, __) {
            return AuthService().userData(user.uid);
          })



        ],child: MaterialApp(

        title: 'AM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.black,
          buttonColor: Colors.black,
          fontFamily: 'Lato',

        ),
        home: TabsScreen(0),
        routes: {
          PostDetail.routeName:(ctx)=>PostDetail(),
          Deals.routeName:(ctx)=>Deals(),
          BlogPage.routeName:(ctx)=>BlogPage(),
          AuthScreen.routeName:(ctx)=>AuthScreen(),
          GameHomeScreen.routeName:(ctx)=>GameHomeScreen(),
          GamesOverallScreen.routeName:(ctx)=>GamesOverallScreen(),
          Profile.routeName:(ctx)=>Profile(),
          EditDealScreen.routeName:(ctx)=>EditDealScreen(),
          EditProfileScreen.routeName:(ctx)=>EditProfileScreen(),
        },
      ),
      );

  }
}