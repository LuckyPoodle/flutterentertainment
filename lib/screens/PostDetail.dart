import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../providers/selected_category.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends StatelessWidget {

  //for when navigating on the fly
  // final String title;
  // ProductDetailScreen(this.title);

  static const routeName='/product-detail';


  @override
  Widget build(BuildContext context) {
    //extract id
    final productId=ModalRoute.of(context).settings.arguments as String;

    // ... want to get all product data using the id, we NEED A CENTRE STATE MANAGEMENT
    //we have provider access
    final loadedProduct=Provider.of<SelectedCategory>(context,listen:false).findById(productId);


    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),

      ),
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal:10),
                height: 300,
                width: double.infinity,
                child:Image.network(loadedProduct.urlToImage,fit: BoxFit.cover,), ),
              SizedBox(height:10),

              SizedBox(height:10),
              Html(
                data: "${loadedProduct.content}",

              ),
            ]
        ),
      ),


    );
  }
}