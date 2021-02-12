import 'package:flutter/material.dart';
import '../utilities/authservice.dart';


class BrandDetailScreen extends StatefulWidget {
  static const routeName='/branddetail';

  @override
  _BrandDetailScreenState createState() => _BrandDetailScreenState();
}

class _BrandDetailScreenState extends State<BrandDetailScreen> {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final productId=ModalRoute.of(context).settings.arguments as String;





    return FutureBuilder(
                      future:auth.getBrandDetail(productId),
                      builder:(ctx, datasnapshot) {
                        if (datasnapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(backgroundColor: Colors.black,),
                          );
                        }
                        final chatDocs = datasnapshot.data;
                        print(chatDocs['brandname']);
                        return Scaffold(appBar: AppBar(automaticallyImplyLeading: true,),
                        body:SingleChildScrollView(child: Column(
                          
                          
                          children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text(chatDocs['brandname'],style: TextStyle(fontSize: 30),),),
  Container(
                      width: 200,
                      height: 200,
                      margin: EdgeInsets.only(top:8,right:10,),
                  
                      child:Image(
             fit: BoxFit.contain,
  image:NetworkImage(chatDocs['profileimg']),
)
                    

                    ),
Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text(chatDocs['description'],style: TextStyle(fontSize: 20),),),


                        ],),));
                      }, );
  }
}