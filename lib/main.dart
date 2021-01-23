import 'package:amcollective/screens/blogpage.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/selected_category.dart';
import 'screens/PostDetail.dart';
import 'screens/deals.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create:(ctx)=>SelectedCategory()
          )

        ],child: MaterialApp(

        title: 'AM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.black,

        ),
        home: TabsScreen(),
        routes: {
          PostDetail.routeName:(ctx)=>PostDetail(),
          Deals.routeName:(ctx)=>Deals(),
          BlogPage.routeName:(ctx)=>BlogPage(),
        },
      ),
      );

  }
}