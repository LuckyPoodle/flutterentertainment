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
                        return Scaffold(
                          appBar: AppBar(
                            iconTheme: IconThemeData( color: Colors.black),
                            automaticallyImplyLeading: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            brightness: Brightness.light,),
                        body:SingleChildScrollView(child: Column(
                          
                          
                          children: <Widget>[

                              Stack(
                                children: <Widget>[
                                 Container(
                                 
          decoration: BoxDecoration(
            
            color: Colors.blue,
            shape: BoxShape.circle
          ),
          child:  Column(children: <Widget>[
                                    
                          Container(
                            width: 200,
                            height: 200,
                           
                        
                            child:Image(
                                fit: BoxFit.contain,
                      image:NetworkImage(chatDocs['profileimg']),
                    )
                  
                    ), 
                  
       
                    Container(
                            
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(30),
                             decoration: BoxDecoration(
            
            color: Colors.white,
            shape: BoxShape.rectangle
          ),
                            child: Text(chatDocs['brandname'],style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),),
                            
                                 ],),),

                                ],
                              ),
                       
                      
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text(chatDocs['description'],style: TextStyle(fontSize: 20),),),

                         Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
              Text("Location(s)"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
            ]),

            for (var doc in chatDocs['outletlist'])
            Text(doc['address'],style: TextStyle(fontSize: 20),)


                        ],),));
                      }, );
  }
}